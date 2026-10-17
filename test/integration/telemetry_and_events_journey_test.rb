require "test_helper"

class TelemetryAndEventsJourneyTest < ActionDispatch::IntegrationTest
  setup do
    @track = Track.create!(
      name: "Нижегородское Кольцо (NRing)",
      location: "Нижегородская область, Богородск",
      length_km: 3.22,
      turns: 15,
      source_key: nil
    )

    @event = Event.create!(
      track: @track,
      title: "NRing Open Track Day",
      date: Date.tomorrow,
      status: "scheduled",
      kind: "track_day",
      organizer: "NRing Circuit"
    )

    @session = TimingSession.create!(
      track: @track,
      event: @event,
      name: "Fast Session 1",
      session_type: "open_pitlane",
      started_at: Time.current - 1.hour,
      status: "finished"
    )

    @pilot = Pilot.create!(
      name: "Сергей Борисов",
      car: "BMW M2 CS Racing",
      pilot_class: "Touring"
    )

    @lap = LapResult.create!(
      timing_session: @session,
      pilot: @pilot,
      lap_number: 5,
      lap_time: 101.250, # 1:41.250
      sector_1_time: 32.100,
      sector_2_time: 35.200,
      sector_3_time: 33.950,
      top_speed: 215.4,
      is_valid: true
    )
  end

  test "complete telemetry and events journey: calendar, track details, live timing session, gps dyno calculate" do
    # 1. Calendar view
    get calendar_url
    assert_response :success
    assert_includes response.body, "NRing Open Track Day"
    assert_includes response.body, "Нижегородское Кольцо (NRing)"

    # 2. Tracks directory
    get tracks_url
    assert_response :success
    assert_includes response.body, "Нижегородское Кольцо (NRing)"

    # 3. Timing index & Session detail
    get timing_url
    assert_response :success
    assert_includes response.body, "Fast Session 1"

    get timing_session_url(@session)
    assert_response :success
    assert_includes response.body, "Сергей Борисов"
    assert_includes response.body, "BMW M2 CS Racing"
    assert_includes response.body, "1:41.250"

    # Check live feed endpoint
    get "/timing/#{@session.id}/live_feed"
    assert_response :success
    json_feed = JSON.parse(response.body)
    assert_equal @session.id, json_feed["session_id"]
    assert json_feed["results"].any? { |l| l["pilot_name"] == "Сергей Борисов" }

    # 4. GPSDyno Power Calculation
    get new_gps_dyno_url
    assert_response :success

    assert_difference("GpsDynoRun.count", 1) do
      post power_url, params: {
        title: "Замер BMW M2 CS Stage 2",
        car_model: "BMW M2 CS Racing",
        car_mass_kg: 1520
      }
    end

    dyno_run = GpsDynoRun.find_by(title: "Замер BMW M2 CS Stage 2")
    assert_not_nil dyno_run
    assert_redirected_to gps_dyno_run_url(dyno_run)
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Замер BMW M2 CS Stage 2"
    assert dyno_run.calculated_hp > 0
    assert dyno_run.calculated_torque_nm > 0
  end
end
