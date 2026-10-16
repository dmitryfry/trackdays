# frozen_string_literal: true

require "json"

module EventSync
  module Adapters
    class IgoraDrive < Base
      BASE = "https://drive-igora.ru"
      EVENTS_URL = "#{BASE}/events/"

      DISCIPLINE_KIND = {
        "ring" => "track_day",
        "carting" => "sport",
        "other" => "other"
      }.freeze

      def source_key
        "igora"
      end

      def fetch
        html = http.get(EVENTS_URL)
        payloads = parse_ld_json(html)
        payloads = parse_html_items(Nokogiri::HTML(html)) if payloads.empty?

        detail_cache = {}
        payloads.each do |payload|
          next unless payload.kind == "track_day" && payload.source_url.present?
          next unless payload.title.to_s.match?(/трек/i)

          detail_cache[payload.source_url] ||= fetch_detail_meta(payload.source_url)
          price, slots = detail_cache[payload.source_url]
          payload.price_rub ||= price
          payload.slots_total ||= slots
        end

        payloads.uniq { |p| p.external_id }
      end

      private

      def parse_ld_json(html)
        doc = Nokogiri::HTML(html)
        payloads = []

        doc.css('script[type="application/ld+json"]').each do |script|
          raw = script.text.to_s.strip
          next if raw.blank?

          data = JSON.parse(raw)
          events = data.is_a?(Array) ? data : [data]
          events.each do |event|
            next unless event.is_a?(Hash) && event["@type"].to_s.include?("Event")

            name = event["name"].to_s.strip
            start_date = Date.parse(event["startDate"].to_s)
            ends_on = event["endDate"].present? ? Date.parse(event["endDate"].to_s) : nil
            ends_on = nil if ends_on == start_date
            url = event["url"].to_s
            next if name.blank?

            payloads << EventSync::Payload.new(
              track_key: source_key,
              title: name,
              date: start_date,
              ends_on: ends_on,
              kind: classify_kind(name),
              organizer: "Igora Drive",
              source_url: url.presence,
              external_id: external_id_from(url, name, start_date)
            )
          end
        rescue JSON::ParserError, ArgumentError, TypeError
          next
        end

        payloads
      end

      def parse_html_items(doc)
        payloads = []
        year = Date.current.year

        doc.css("a.d-events__item, .d-events__item").each do |item|
          title = item.at_css(".d-events__item-title")&.text&.strip
          number = item.at_css(".d-events__item-date-number")&.text&.strip
          month = item.at_css(".d-events__item-date-month")&.text&.strip
          next if title.blank? || number.blank? || month.blank?

          day = number.split("-").first.to_i
          date = parse_russian_date("#{day} #{month}", default_year: year)
          next unless date

          ends_on = nil
          if number.include?("-")
            end_day = number.split("-").last.to_i
            ends_on = parse_russian_date("#{end_day} #{month}", default_year: year)
          end

          href = item["href"] || item.at_css("a")&.[]("href")
          source_url = absolute_url(BASE, href)
          kind = kind_from_classes(item["class"]) || classify_kind(title)

          payloads << EventSync::Payload.new(
            track_key: source_key,
            title: title,
            date: date,
            ends_on: ends_on,
            kind: kind,
            organizer: "Igora Drive",
            source_url: source_url,
            external_id: external_id_from(source_url, title, date)
          )
        end

        payloads
      end

      def kind_from_classes(classes)
        list = Array(classes)
        return "track_day" if list.any? { |c| c.include?("ring") } && list.none? { |c| c.include?("carting") }
        return "sport" if list.any? { |c| c.include?("carting") || c.include?("drift") }

        nil
      end

      def external_id_from(url, title, date)
        if url.present?
          path = url.sub(%r{\Ahttps?://[^/]+}, "").sub(%r{/\z}, "")
          return "#{path}|#{date.iso8601}"
        end

        digest_id(title, date.iso8601)
      end

      def fetch_detail_meta(url)
        return [nil, nil] unless url.include?("drive-igora.ru")

        doc = get_html(url)
        text = doc.text
        price = nil
        slots = nil
        if (m = text.match(/Стоимость\s*([\d\s]+)\s*рубл/i))
          price = parse_price(m[1])
        end
        if (m = text.match(/максимум\s+(\d+)\s+участник/i))
          slots = m[1].to_i
        end
        [price, slots]
      rescue EventSync::HttpClient::Error
        [nil, nil]
      end
    end
  end
end
