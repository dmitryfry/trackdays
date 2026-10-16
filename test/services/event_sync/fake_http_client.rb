# frozen_string_literal: true

module EventSync
  class FakeHttpClient
    def initialize(map)
      @map = map
    end

    def get(url, headers: {})
      match = @map.keys
                  .select { |pattern| url.include?(pattern) }
                  .max_by(&:length)
      return @map.fetch(match) if match

      raise EventSync::HttpClient::Error, "No fixture for #{url}"
    end
  end
end
