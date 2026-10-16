# frozen_string_literal: true

module EventSync
  module Adapters
    # Moscow Raceway calendars are SPA-heavy; we harvest announcement news which list
    # track-day dates and sport events in SSR HTML.
    class MoscowRaceway < Base
      BASE = "https://moscowraceway.ru"
      NEWS_URL = "#{BASE}/news/announcement"
      HOME_URL = "#{BASE}/"
      TICKETS_URL = "https://tickets.moscowraceway.ru/"

      def source_key
        "mrv"
      end

      def fetch
        payloads = []
        payloads.concat(fetch_from_home)
        payloads.concat(fetch_from_news_index)
        payloads.concat(fetch_from_tickets)
        enrich_track_day_articles!(payloads)
        payloads.uniq { |p| p.external_id }
      end

      private

      def fetch_from_home
        doc = get_html(HOME_URL)
        parse_news_links(doc, default_kind: nil)
      rescue EventSync::HttpClient::Error => e
        Rails.logger.warn("[EventSync] mrv home: #{e.message}")
        []
      end

      def fetch_from_news_index
        doc = get_html(NEWS_URL)
        parse_news_links(doc, default_kind: nil)
      rescue EventSync::HttpClient::Error => e
        Rails.logger.warn("[EventSync] mrv news: #{e.message}")
        []
      end

      def fetch_from_tickets
        doc = get_html(TICKETS_URL)
        payloads = []
        doc.css("a, h1, h2, h3, .card, .event").each do |el|
          text = el.text.to_s.gsub(/\s+/, " ").strip
          next if text.length < 5 || text.length > 160

          dates = extract_dates_from_title(text)
          next if dates.empty?

          href = el["href"] if el.name == "a"
          source_url = href.present? ? absolute_url(TICKETS_URL, href) : TICKETS_URL
          kind = classify_kind(text)
          title = text

          dates.each do |date|
            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: title,
              date: date,
              kind: kind,
              organizer: "Moscow Raceway",
              source_url: source_url,
              external_id: digest_id(title, date.iso8601)
            )
          end
        end
        payloads
      rescue EventSync::HttpClient::Error => e
        Rails.logger.warn("[EventSync] mrv tickets: #{e.message}")
        []
      end

      def parse_news_links(doc, default_kind:)
        payloads = []
        doc.css("a[href*='/news/']").each do |a|
          title = a.text.to_s.gsub(/\s+/, " ").strip
          href = a["href"].to_s.split("?").first
          next if title.blank? || title.length < 5
          next if title.match?(/\Aвсе\b/i)
          next unless href.include?("/news/")

          source_url = absolute_url(BASE, href)
          kind = default_kind || classify_kind(title)
          dates = extract_dates_from_title(title)

          if dates.empty? && title.match?(/трек/i)
            # Will be enriched from article body later
            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: title,
              date: Date.current, # placeholder replaced in enrich
              kind: "track_day",
              organizer: "Moscow Raceway",
              source_url: source_url,
              external_id: "pending|#{digest_id(source_url)}"
            )
            next
          end

          next if dates.empty?

          dates.each do |date|
            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: title,
              date: date,
              kind: kind,
              organizer: "Moscow Raceway",
              source_url: source_url,
              external_id: digest_id(title, date.iso8601)
            )
          end
        end
        payloads
      end

      def enrich_track_day_articles!(payloads)
        pending = payloads.select do |p|
          p.external_id.start_with?("pending|") ||
            (p.kind == "track_day" && p.source_url.to_s.include?("/news/") && p.title.to_s.match?(/трек/i))
        end
        seen_urls = {}

        pending.first(8).each do |payload|
          url = payload.source_url
          next if url.blank? || seen_urls[url]

          seen_urls[url] = true
          article_dates = fetch_article_dates(url)
          next if article_dates.empty?

          payloads.delete(payload) if payload.external_id.start_with?("pending|")

          article_dates.each do |date|
            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: normalize_track_day_title(payload.title, date),
              date: date,
              kind: "track_day",
              organizer: "Moscow Raceway",
              source_url: url,
              external_id: digest_id("track-day", date.iso8601)
            )
          end
        rescue EventSync::HttpClient::Error => e
          Rails.logger.warn("[EventSync] mrv article #{url}: #{e.message}")
        end

        payloads.reject! { |p| p.external_id.start_with?("pending|") }
      end

      def fetch_article_dates(url)
        doc = get_html(url)
        text = doc.text
        year = infer_year(text)
        dates = []

        # "в среду, 22 июля" / "22 июля, среда"
        text.scan(/(\d{1,2})\s+(января|февраля|марта|апреля|мая|июня|июля|августа|сентября|октября|ноября|декабря)/i).each do |day, month|
          date = parse_russian_date("#{day} #{month}", default_year: year)
          dates << date if date
        end

        # Title pattern already handled; also "Трек-дни: 12, 14 и 16 августа"
        if (m = doc.at_css("h1")&.text.to_s.match(/([\d,\sи]+)\s+([а-яё]+)/i))
          month = m[2]
          m[1].scan(/\d{1,2}/).each do |day|
            date = parse_russian_date("#{day} #{month}", default_year: year)
            dates << date if date
          end
        end

        dates.uniq.select { |d| d >= Date.current - 7 }
      end

      def infer_year(text)
        if (m = text.match(/\b(20\d{2})\b/))
          m[1].to_i
        else
          Date.current.year
        end
      end

      def extract_dates_from_title(title)
        year = Date.current.year
        dates = []

        # "Трек-дни: 12, 14 и 16 августа" / "Мото-трек-дни: 4-6 сентября"
        if (m = title.match(/([\d,\sи\-–]+)\s+([а-яё]+)\b/i))
          month = m[2]
          next_dates = []
          if (range = m[1].match(/(\d{1,2})\s*[\-–]\s*(\d{1,2})/))
            (range[1].to_i..range[2].to_i).each do |day|
              date = parse_russian_date("#{day} #{month}", default_year: year)
              next_dates << date if date
            end
          else
            m[1].scan(/\d{1,2}/).each do |day|
              date = parse_russian_date("#{day} #{month}", default_year: year)
              next_dates << date if date
            end
          end
          return next_dates if next_dates.any?
        end

        if (date = parse_russian_date(title, default_year: year))
          dates << date
        end

        dates
      end

      def normalize_track_day_title(title, date)
        return "Авто трек-день" if title.match?(/трек/i) && !title.match?(/мото/i)
        return "Мото трек-день" if title.match?(/мото/i)

        title
      end
    end
  end
end
