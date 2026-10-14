require "test_helper"

class PilotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = Team.create!(name: "Test Team", slug: "test-team")
    @pilot = Pilot.create!(
      name: "Петр Скоростной",
      car: "Lada Vesta TCR",
      team: @team,
      pilot_class: "TCR",
      points: 80
    )
  end

  test "should get index" do
    get pilots_url
    assert_response :success
    assert_includes response.body, "Петр Скоростной"
  end

  test "should show pilot" do
    get pilot_url(@pilot)
    assert_response :success
    assert_includes response.body, "Петр Скоростной"
    assert_includes response.body, "Lada Vesta TCR"
  end
end
