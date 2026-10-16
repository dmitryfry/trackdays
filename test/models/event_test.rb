require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @track = tracks(:one)
  end

  test "validates inclusion of kind" do
    event = Event.new(track: @track, date: Date.current, title: "Test", kind: "track_day", status: "scheduled")
    assert event.valid?

    event.kind = "invalid_kind"
    assert_not event.valid?
    assert_includes event.errors[:kind], "is not included in the list"
  end

  test "validates inclusion of status" do
    event = Event.new(track: @track, date: Date.current, title: "Test", kind: "track_day", status: "scheduled")
    assert event.valid?

    event.status = "unknown_status"
    assert_not event.valid?
    assert_includes event.errors[:status], "is not included in the list"
  end

  test "validates uniqueness of external_id scoped to source" do
    Event.create!(
      track: @track,
      date: Date.current,
      title: "Event 1",
      kind: "track_day",
      status: "scheduled",
      source: "igora",
      external_id: "ext-100"
    )

    duplicate = Event.new(
      track: @track,
      date: Date.current + 1.day,
      title: "Event 2",
      kind: "track_day",
      status: "scheduled",
      source: "igora",
      external_id: "ext-100"
    )
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:external_id], "has already been taken"

    diff_source = Event.new(
      track: @track,
      date: Date.current + 1.day,
      title: "Event 3",
      kind: "track_day",
      status: "scheduled",
      source: "mrv",
      external_id: "ext-100"
    )
    assert diff_source.valid?
  end

  test "scopes filter events properly" do
    past_event = Event.create!(
      track: @track,
      date: Date.current - 5.days,
      title: "Past",
      kind: "track_day",
      status: "scheduled"
    )
    upcoming_event = Event.create!(
      track: @track,
      date: Date.current + 2.days,
      title: "Upcoming",
      kind: "sport",
      status: "scheduled"
    )
    cancelled_event = Event.create!(
      track: @track,
      date: Date.current + 3.days,
      title: "Cancelled",
      kind: "track_day",
      status: "cancelled"
    )

    scheduled = Event.scheduled
    assert_includes scheduled, past_event
    assert_includes scheduled, upcoming_event
    assert_not_includes scheduled, cancelled_event

    upcoming = Event.upcoming
    assert_includes upcoming, upcoming_event
    assert_not_includes upcoming, past_event
    assert_not_includes upcoming, cancelled_event
  end

  test "helper methods track_day? and kind_label" do
    event = Event.new(kind: "track_day")
    assert event.track_day?
    assert_equal "Track Day", event.kind_label

    sport_event = Event.new(kind: "sport")
    assert_not sport_event.track_day?
    assert_equal "Спорт", sport_event.kind_label

    other_event = Event.new(kind: "other")
    assert_equal "Другое", other_event.kind_label
  end
end
