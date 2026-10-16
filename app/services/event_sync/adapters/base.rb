# frozen_string_literal: true

require "digest"
require "nokogiri"

module EventSync
  module Adapters
    class Base
      attr_reader :http

      def initialize(http: EventSync::HttpClient.new)
        @http = http
      end

      def source_key
        raise NotImplementedError
      end

      def fetch
        raise NotImplementedError
      end

      protected

      def get_html(url)
        Nokogiri::HTML(http.get(url))
      end

      def absolute_url(base, path)
        return path if path.blank? || path.start_with?("http")

        URI.join(base, path).to_s
      end

      def digest_id(*parts)
        Digest::SHA256.hexdigest(parts.compact.join("|"))[0, 24]
      end

      def parse_price(text)
        return nil if text.blank?

        digits = text.gsub(/\s+/, "").scan(/\d+/).join
        digits.present? ? digits.to_i : nil
      end

      RU_MONTHS = {
        "январ" => 1, "феврал" => 2, "март" => 3, "апрел" => 4,
        "ма" => 5, "июн" => 6, "июл" => 7, "август" => 8,
        "сентябр" => 9, "октябр" => 10, "ноябр" => 11, "декабр" => 12
      }.freeze

      def parse_russian_date(text, default_year: Date.current.year)
        return nil if text.blank?

        cleaned = text.to_s.strip.downcase.tr("ё", "е")

        if (m = cleaned.match(/(\d{1,2})\.(\d{1,2})\.(\d{4})/))
          return Date.new(m[3].to_i, m[2].to_i, m[1].to_i)
        end

        if (m = cleaned.match(/(\d{1,2})\.(\d{1,2})\.(\d{2})\b/))
          year = 2000 + m[3].to_i
          return Date.new(year, m[2].to_i, m[1].to_i)
        end

        if (m = cleaned.match(/(\d{1,2})\s+([а-я]+)/))
          day = m[1].to_i
          month_word = m[2]
          month = RU_MONTHS.find { |prefix, _| month_word.start_with?(prefix) }&.last
          return nil unless month

          year = default_year
          date = Date.new(year, month, day)
          # Only roll into next year when the date is far in the past (cross-season titles like "15 января")
          date = date.next_year if date < (Date.current << 8)
          return date
        end

        nil
      rescue ArgumentError
        nil
      end

      def classify_kind(title)
        t = title.to_s.downcase.tr("ё", "е").gsub(/[\u2010-\u2015\u2212]/, "-")
        return "track_day" if t.match?(/трек\s*-?\s*д|track\s*day|open\s*pit|open\s*track/)
        return "sport" if t.match?(/чемпионат|кубок|этап|гонка|сери|time\s*attack|тайм.?атак|рскг|дрифт|sprint|марафон|классик/)

        "other"
      end
    end
  end
end
