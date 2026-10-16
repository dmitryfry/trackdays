# frozen_string_literal: true

require "test_helper"

class EventSyncUpserterTest < ActiveSupport::TestCase
  setup do
    @track = Track.create!(
      name: "NRing Test",
      location: "NN",
      source_key: "nring",
      official_url: "https://nring.ru/"
    )
  end

  test "upserts by source and external_id" do
    payload = EventSync::Payload.new(
      track_key: "nring",
      title: "АВТО трек-день",
      date: Date.current + 10,
      kind: "track_day",
      price_rub: 2500,
      organizer: "NRing",
      source_url: "https://nring.ru/calendar/x/",
      external_id: "/calendar/x"
    )

    result = EventSync::Upserter.new(source: "nring").call([payload])
    assert_equal 1, result.created
    assert_equal 1, Event.where(source: "nring").count

    payload.title = "АВТО трек-день (обновлено)"
    result = EventSync::Upserter.new(source: "nring").call([payload])
    assert_equal 1, result.updated
    assert_equal "АВТО трек-день (обновлено)", Event.find_by(source: "nring").title
  end

  test "does not touch manual events" do
    Event.create!(
      track: @track,
      title: "Manual",
      date: Date.current + 20,
      kind: "track_day",
      status: "scheduled",
      organizer: "Local"
    )

    EventSync::Upserter.new(source: "nring").call([])
    assert Event.exists?(title: "Manual", source: nil)
  end
end
