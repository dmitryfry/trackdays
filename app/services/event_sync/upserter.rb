# frozen_string_literal: true

module EventSync
  class Upserter
    HORIZON_DAYS = 14

    Result = Struct.new(:created, :updated, :cancelled, :skipped, keyword_init: true)

    def initialize(source:)
      @source = source
      @created = 0
      @updated = 0
      @cancelled = 0
      @skipped = 0
    end

    def call(payloads)
      seen_ids = []
      track = Track.find_by!(source_key: @source)

      payloads.each do |payload|
        unless payload.valid?
          @skipped += 1
          next
        end

        seen_ids << payload.external_id
        event = Event.find_or_initialize_by(source: @source, external_id: payload.external_id)
        was_new = event.new_record?

        event.assign_attributes(
          track: track,
          title: payload.title,
          date: payload.date,
          ends_on: payload.ends_on,
          kind: payload.kind.presence || "track_day",
          price_rub: payload.price_rub,
          slots_total: payload.slots_total,
          slots_booked: payload.slots_booked || event.slots_booked || 0,
          organizer: payload.organizer.presence || track.name,
          source_url: payload.source_url,
          status: "scheduled",
          synced_at: Time.current
        )

        if event.changed?
          event.save!
          was_new ? @created += 1 : @updated += 1
        else
          event.update_column(:synced_at, Time.current)
        end
      end

      cancel_missing!(seen_ids)

      Result.new(created: @created, updated: @updated, cancelled: @cancelled, skipped: @skipped)
    end

    private

    def cancel_missing!(seen_ids)
      horizon = Date.current + HORIZON_DAYS
      scope = Event.imported.where(source: @source, status: "scheduled")
                   .where("date >= ?", horizon)

      scope = scope.where.not(external_id: seen_ids) if seen_ids.any?
      scope = scope.where("1=0") if seen_ids.empty? && @created.zero? && @updated.zero?

      # Only cancel when we successfully saw a non-empty feed; empty feed may mean scrape failure
      return if seen_ids.empty?

      count = scope.update_all(status: "cancelled", synced_at: Time.current)
      @cancelled += count
    end
  end
end
