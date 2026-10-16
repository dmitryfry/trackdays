# frozen_string_literal: true

module EventSync
  module Adapters
    class Nring < Base
      BASE = "https://nring.ru"
      CALENDAR_URL = "#{BASE}/calendar/"

      def source_key
        "nring"
      end

      def fetch
        doc = get_html(CALENDAR_URL)
        payloads = []

        doc.css(".closest-events__block").each do |block|
          title_el = block.at_css(".closest-events__block-title h3, .closest-events__block-title a")
          date_el = block.at_css(".closest-events__date span")
          link = block.at_css(".closest-events__block-title a, a[href*='/calendar/']")
          next unless title_el && date_el

          title = title_el.text.strip
          date = parse_russian_date(date_el.text.strip)
          next unless title.present? && date

          href = link&.[]("href")
          source_url = absolute_url(BASE, href)
          external_id = href.present? ? href.sub(%r{\Ahttps?://[^/]+}, "").sub(%r{/\z}, "") : digest_id(title, date.iso8601)

          price = nil
          slots_total = nil
          if source_url.present? && classify_kind(title) == "track_day"
            price, slots_total = fetch_detail_meta(source_url)
          end

          payloads << EventSync::Payload.new(
            track_key: source_key,
            title: title,
            date: date,
            kind: classify_kind(title),
            price_rub: price,
            slots_total: slots_total,
            organizer: "NRing",
            source_url: source_url,
            external_id: external_id
          )
        end

        payloads.uniq { |p| p.external_id }
      end

      private

      def fetch_detail_meta(url)
        doc = get_html(url)
        text = doc.text
        price = nil
        if (m = text.match(/Стоимость[^\d]*([\d\s]+)\s*руб/i)) || (m = text.match(/Стартовый взнос\s*(\d+)/i))
          price = parse_price(m[1])
        end
        # Do not parse participant tables (PII)
        [price, nil]
      rescue EventSync::HttpClient::Error
        [nil, nil]
      end
    end
  end
end
