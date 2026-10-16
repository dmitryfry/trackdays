require "test_helper"

class GarageControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pilot = Pilot.create!(name: "Михаил Алешин", pilot_class: "GT", car: "Porsche 911 GT3")
    @car = GarageCar.create!(
      pilot: @pilot,
      make: "Porsche",
      model: "911 GT3 RS",
      year: 2022,
      car_class: "GT",
      mass_kg: 1430,
      power_hp: 525,
      drivetrain: "RWD",
      specs: "- Suspension: KW Clubsport\n- Brakes: PFC",
      for_rent: true,
      car_of_the_week: true
    )
    @entry = @car.logbook_entries.create!(
      title: "Тестовый выезд на Moscow Raceway",
      content: "Прикатка новых колодок и проверка геометрии подвески.",
      date: Date.current,
      onboard_video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    )
  end

  test "should get index" do
    get garage_url
    assert_response :success
    assert_select "h1", text: /Гараж сообщества/
    assert_select "h2", text: /Porsche 911 GT3 RS/
  end

  test "should filter by rent" do
    get garage_url, params: { filter: "rent" }
    assert_response :success
    assert_select "h3", text: /Porsche 911 GT3 RS/
  end

  test "should get show" do
    get garage_car_url(@car)
    assert_response :success
    assert_select "h1", text: /Porsche 911 GT3 RS/
    assert_select "h4", text: /Тестовый выезд на Moscow Raceway/
  end

  test "should get feed" do
    get garage_feed_url
    assert_response :success
    assert_select "h1", text: /Лента обновлений бортжурналов/
    assert_select "h3", text: /Porsche 911 GT3 RS/
  end

  test "should get new" do
    get new_garage_car_url
    assert_response :success
    assert_select "h1", text: /Добавить автомобиль в Гараж/
  end

  test "should create garage car" do
    assert_difference("GarageCar.count") do
      post garage_url, params: {
        garage_car: {
          pilot_id: @pilot.id,
          make: "BMW",
          model: "M3 E92",
          year: 2011,
          car_class: "Touring",
          mass_kg: 1550,
          power_hp: 420,
          drivetrain: "RWD"
        }
      }
    end

    car = GarageCar.last
    assert_equal 3.69, car.weight_power_ratio
    assert_redirected_to garage_car_url(car)
  end

  test "should create logbook entry" do
    assert_difference("@car.logbook_entries.count") do
      post create_logbook_entry_url(@car), params: {
        logbook_entry: {
          title: "Замена масла и фильтров",
          content: "Залит Motul 300V 15W50 перед трек-днем",
          date: Date.current
        }
      }
    end

    assert_redirected_to garage_car_url(@car)
  end
end
