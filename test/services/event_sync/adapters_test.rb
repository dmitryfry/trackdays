# frozen_string_literal: true

require "test_helper"
require_relative "fake_http_client"

class EventSyncAdaptersTest < ActiveSupport::TestCase
  def fixture(name)
    File.read(Rails.root.join("test/fixtures/files/event_sync/#{name}"))
  end

  test "nring adapter parses closest events" do
    http = EventSync::FakeHttpClient.new(
      "/calendar/avto-trek-den" => fixture("nring_detail.html"),
      "/calendar/" => fixture("nring_calendar.html")
    )
    payloads = EventSync::Adapters::Nring.new(http: http).fetch

    assert payloads.size >= 5, "expected events, got #{payloads.map(&:title).inspect}"
    track_day = payloads.find { |p| p.title.include?("АВТО трек-день") }
    assert track_day, "missing track day in #{payloads.map { |p| [p.title, p.kind] }.inspect}"
    assert_equal "nring", track_day.track_key
    assert_equal Date.new(2026, 8, 21), track_day.date
    assert_equal "track_day", track_day.kind
    assert_equal 2500, track_day.price_rub
  end

  test "igora adapter parses ld+json events" do
    http = EventSync::FakeHttpClient.new(
      "https://drive-igora.ru/events/" => fixture("igora_events.html"),
      "/service/" => "<html><body>Стоимость 35 000 рублей максимум 40 участников</body></html>",
      "/events/" => "<html><body>Стоимость 35 000 рублей максимум 40 участников</body></html>"
    )
    payloads = EventSync::Adapters::IgoraDrive.new(http: http).fetch

    assert payloads.size >= 5, "got #{payloads.size}: #{payloads.map(&:title).first(5)}"
    sample = payloads.find { |p| p.title.include?("Балтика") }
    assert sample
    assert_equal Date.new(2026, 8, 22), sample.date
    assert_equal Date.new(2026, 8, 23), sample.ends_on
    assert sample.source_url.present?
  end

  test "kazan adapter parses calendar dates" do
    http = EventSync::FakeHttpClient.new(
      "/auto" => fixture("kazan_auto.html"),
      "/timeattack" => fixture("kazan_timeattack.html"),
      "/moto" => fixture("kazan_moto.html")
    )
    payloads = EventSync::Adapters::KazanCanyon.new(http: http).fetch

    assert payloads.any? { |p| p.date.month == 4 && p.date.day == 25 && p.kind == "track_day" },
           payloads.map { |p| [p.date, p.kind] }.inspect
    assert payloads.any? { |p| p.date.month == 8 && p.date.day == 22 }
    assert payloads.any? { |p| p.price_rub == 6000 }
    assert payloads.any? { |p| p.date.month == 5 && p.title.include?("Мото") }
  end

  test "smolensk adapter parses news calendar lines" do
    http = Object.new
    def http.get(url, headers: {})
      raise EventSync::HttpClient::Error, "HTTP 403" if url.end_with?("/calendar")

      File.read(Rails.root.join("test/fixtures/files/event_sync/smolensk_news.html"))
    end

    payloads = EventSync::Adapters::SmolenskRing.new(http: http).fetch
    assert payloads.any? { |p| p.title.match?(/Трек-дн/i) }
    assert payloads.any? { |p| p.title.include?("Classic Touring") && p.ends_on.present? }
  end

  test "mrv adapter extracts track day dates from news" do
    http = EventSync::FakeHttpClient.new(
      "https://moscowraceway.ru/news/announcement/track-12-16-aug-26" => fixture("mrv_track_article.html"),
      "https://moscowraceway.ru/news/announcement/trd-sept-26" => fixture("mrv_track_article.html"),
      "https://moscowraceway.ru/news/announcement" => fixture("mrv_news.html"),
      "https://moscowraceway.ru/" => fixture("mrv_home.html"),
      "https://tickets.moscowraceway.ru/" => fixture("mrv_tickets.html")
    )
    payloads = EventSync::Adapters::MoscowRaceway.new(http: http).fetch

    assert payloads.any? { |p| p.kind == "track_day" && [12, 14, 16].include?(p.date.day) && p.date.month == 8 }
  end
end
