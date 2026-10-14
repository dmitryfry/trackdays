require "test_helper"

class GpsDynoControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dyno = GpsDynoRun.create!(
      title: "Test Dyno Car",
      car_model: "Porsche 911",
      car_mass_kg: 1450,
      calculated_hp: 450,
      calculated_torque_nm: 500,
      run_date: Date.current
    )
  end

  test "should get index" do
    get power_url
    assert_response :success
    assert_includes response.body, "Test Dyno Car"
  end

  test "should get new" do
    get new_gps_dyno_url
    assert_response :success
    assert_select "form"
  end

  test "should create dyno run from simulation params" do
    assert_difference("GpsDynoRun.count", 1) do
      post "/power", params: {
        title: "Golf R Dyno Run",
        car_model: "VW Golf R",
        car_mass_kg: 1550,
        accel_time_s: 8.5
      }
    end
    assert_redirected_to gps_dyno_run_path(GpsDynoRun.last)
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Golf R Dyno Run"
  end

  test "should show dyno run with svg curve" do
    get gps_dyno_run_url(@dyno)
    assert_response :success
    assert_includes response.body, "Test Dyno Car"
    assert_includes response.body, "450"
  end
end
