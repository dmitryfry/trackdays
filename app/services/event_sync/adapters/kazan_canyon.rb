# frozen_string_literal: true

module EventSync
  module Adapters
    class KazanCanyon < Base
      BASE = "https://kznring.ru"
      PAGES = {
        "auto" => { url: "#{BASE}/auto", title_prefix: "Авто трек-день", kind: "track_day", default_price: 6000 },
        "timeattack" => { url: "#{BASE}/timeattack", title_prefix: "KazanRing Time Attack", kind: "sport", default_price: nil },
        "moto" => { url: "#{BASE}/moto", title_prefix: "Мото трек-день", kind: "track_day", default_price: nil }
      }.freeze

      def source_key
        "kazan"
      end

      def fetch
        payloads = []
        year = Date.current.year

        PAGES.each do |page_key, meta|
          doc = get_html(meta[:url])
          price = extract_price(doc) || meta[:default_price]
          dates = extract_dates(doc, year)

          dates.each do |date, note|
            title = build_title(meta[:title_prefix], note)
            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: title,
              date: date,
              kind: meta[:kind],
              price_rub: price,
              organizer: "KazanRing Canyon",
              source_url: meta[:url],
              external_id: "#{page_key}|#{date.iso8601}"
            )
          end
        rescue EventSync::HttpClient::Error => e
          Rails.logger.warn("[EventSync] kazan #{page_key}: #{e.message}")
        end

        payloads.uniq { |p| p.external_id }
      end

      private

      def extract_dates(doc, year)
        results = []
        doc.css(".t550__title, .t-name_lg").each do |el|
          text = el.text.to_s.gsub(/\s+/, " ").strip
          next if text.blank?

          dates = expand_date_text(text, year)
          next if dates.empty?

          note = text.sub(/\A[\d\-\s]+\s+[А-Яа-яA-Za-z]+\s*/u, "").gsub(%r{[/\(\)]}, " ").squeeze(" ").strip
          note = nil if note.blank? || note.match?(/\Aфото\z/i) || note.match?(/регистраци/i)
          dates.each { |date| results << [date, note] }
        end
        results
      end

      def expand_date_text(text, year)
        cleaned = text.downcase.tr("ё", "е")
        if (m = cleaned.match(/(\d{1,2})\s*[\-–]\s*(\d{1,2})\s+([а-я]+)/))
          month_word = m[3]
          (m[1].to_i..m[2].to_i).filter_map do |day|
            parse_russian_date("#{day} #{month_word}", default_year: year)
          end
        else
          date = parse_russian_date(text, default_year: year)
          date ? [date] : []
        end
      end

      def extract_price(doc)
        text = doc.text
        if (m = text.match(/(\d[\d\s]*)\s*рубл[^\n]{0,40}OPEN\s*PITLANE/i)) ||
           (m = text.match(/OPEN\s*PITLANE[^\d]{0,20}(\d[\d\s]*)/i)) ||
           (m = text.match(/ОПЛАТИТЬ СЕССИЮ[^\d]*(\d[\d\s]*)/i))
          return parse_price(m[1])
        end

        nil
      end

      def build_title(prefix, note)
        return prefix if note.blank?

        "#{prefix}: #{note}"
      end
    end
  end
end
