# frozen_string_literal: true

module EventSync
  module Adapters
    # Smolensk Ring (Tilda). Live site may return 403 to bots; adapter works on fixtures
    # and when calendar/news pages are reachable.
    class SmolenskRing < Base
      BASE = "https://smolenskring.ru"
      CALENDAR_URL = "#{BASE}/calendar"

      NEWS_PATHS = [
        "/news/tpost/ro9mgh9n21-kalendar-sportivnih-sobitii-na-smolensko",
        "/news/tpost/uore5tcex1-opublikovan-kalendar-meropriyatii-na-smo"
      ].freeze

      def source_key
        "smolensk"
      end

      def fetch
        payloads = fetch_calendar
        payloads = fetch_news_calendars if payloads.empty?
        payloads.uniq { |p| p.external_id }
      end

      private

      def fetch_calendar
        doc = get_html(CALENDAR_URL)
        parse_event_cards(doc) + parse_date_lines(doc.text, source_url: CALENDAR_URL)
      rescue EventSync::HttpClient::Error
        []
      end

      def fetch_news_calendars
        payloads = []
        NEWS_PATHS.each do |path|
          url = absolute_url(BASE, path)
          doc = get_html(url)
          payloads.concat(parse_date_lines(doc.text, source_url: url))
        rescue EventSync::HttpClient::Error => e
          Rails.logger.warn("[EventSync] smolensk news #{path}: #{e.message}")
        end
        payloads
      end

      def parse_event_cards(doc)
        payloads = []
        doc.css("a, .t-card__title, .t-name, .tn-atom").each do |el|
          text = el.text.to_s.gsub(/\s+/, " ").strip
          next unless text.match?(/трек/i)
          next unless (date = parse_russian_date(text))

          href = el["href"] if el.name == "a"
          source_url = href.present? ? absolute_url(BASE, href) : CALENDAR_URL
          title = text.sub(/\A[\d\.\s]+/, "").strip
          title = "Трек-день" if title.blank? || title.length < 4

          payloads << EventSync::Payload.new(
            track_key: source_key,
            title: title[0, 180],
            date: date,
            kind: classify_kind(title),
            organizer: "Смоленское кольцо",
            source_url: source_url,
            external_id: digest_id(title, date.iso8601)
          )
        end
        payloads
      end

      # Parses lines like "7 мая: Трек-день" or "8 и 9 мая: Classic Touring"
      def parse_date_lines(text, source_url:)
        payloads = []
        year = Date.current.year

        text.to_s.each_line do |line|
          cleaned = line.gsub(/\s+/, " ").strip
          next if cleaned.blank?

          if (m = cleaned.match(/(\d{1,2})\s+и\s+(\d{1,2})\s+([а-яё]+)[:\s]+(.+)/i))
            month = m[3]
            title = m[4].strip
            start_date = parse_russian_date("#{m[1]} #{month}", default_year: year)
            end_date = parse_russian_date("#{m[2]} #{month}", default_year: year)
            next unless start_date

            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: title,
              date: start_date,
              ends_on: end_date,
              kind: classify_kind(title),
              organizer: "Смоленское кольцо",
              source_url: source_url,
              external_id: digest_id(title, start_date.iso8601)
            )
            next
          end

          next unless (m = cleaned.match(/(\d{1,2})\s+([а-яё]+)[:\s]+(.+)/i))

          date = parse_russian_date("#{m[1]} #{m[2]}", default_year: year)
          title = m[3].strip
          next unless date && title.present? && title.length > 3
          next unless title.match?(/трек|кубок|чемпионат|cup|attack|гонка|марафон|классик|maxpower|серия|этап/i)

          payloads << EventSync::Payload.new(
            track_key: source_key,
            title: title,
            date: date,
            kind: classify_kind(title),
            organizer: "Смоленское кольцо",
            source_url: source_url,
            external_id: digest_id(title, date.iso8601)
          )
        end

        payloads
      end
    end
  end
end
