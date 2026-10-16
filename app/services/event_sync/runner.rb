# frozen_string_literal: true

module EventSync
  class Runner
    ADAPTERS = {
      "nring" => "EventSync::Adapters::Nring",
      "igora" => "EventSync::Adapters::IgoraDrive",
      "kazan" => "EventSync::Adapters::KazanCanyon",
      "smolensk" => "EventSync::Adapters::SmolenskRing",
      "mrv" => "EventSync::Adapters::MoscowRaceway"
    }.freeze

    Result = Struct.new(:source, :fetched, :upsert, :error, keyword_init: true)

    def initialize(sources: nil, http: EventSync::HttpClient.new)
      @sources = Array(sources).presence || ADAPTERS.keys
      @http = http
    end

    def call
      @sources.map { |key| sync_one(key) }
    end

    private

    def sync_one(key)
      adapter_class = ADAPTERS.fetch(key).constantize
      adapter = adapter_class.new(http: @http)
      payloads = adapter.fetch
      upsert = Upserter.new(source: key).call(payloads)

      Rails.logger.info(
        "[EventSync] #{key}: fetched=#{payloads.size} " \
        "created=#{upsert.created} updated=#{upsert.updated} " \
        "cancelled=#{upsert.cancelled} skipped=#{upsert.skipped}"
      )

      Result.new(source: key, fetched: payloads.size, upsert: upsert, error: nil)
    rescue KeyError
      Result.new(source: key, fetched: 0, upsert: nil, error: "Unknown source: #{key}")
    rescue StandardError => e
      Rails.logger.error("[EventSync] #{key} failed: #{e.class}: #{e.message}")
      Result.new(source: key, fetched: 0, upsert: nil, error: e.message)
    end
  end
end
