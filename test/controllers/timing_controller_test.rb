require "test_helper"

class TimingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = Track.create!(name: "Test Ring", length_km: 3.5, turns: 12)
    @timing_session = TimingSession.create!(
      track: @track,
      name: "Track Day Session 1",
      session_type: "track_day",
      status: "live",
      started_at: Time.current
    )
    @pilot = Pilot.create!(name: "Иван Тестов", car: "BMW M3")
    @lap = LapResult.create!(
      timing_session: @timing_session,
      pilot: @pilot,
      lap_number: 1,
      lap_time: 98.420,
      sector_1_time: 28.5,
      sector_2_time: 37.2,
      sector_3_time: 32.72,
      top_speed: 220.5,
      is_valid: true
    )
  end

  test "should get index" do
    get timing_url
    assert_response :success
    assert_select "h1", text: /Live Timing/i
  end

  test "should show timing session" do
    get timing_session_url(@timing_session)
    assert_response :success
    assert_includes response.body, "Track Day Session 1"
    assert_includes response.body, "Иван Тестов"
  end

  test "should get live feed json" do
    get "/timing/#{@timing_session.id}/live_feed"
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @timing_session.id, json["session_id"]
    assert_equal 1, json["results"].length
    assert_equal "Иван Тестов", json["results"].first["pilot_name"]
  end
end
