require "test_helper"

class MarketAndSimracingJourneyTest < ActionDispatch::IntegrationTest
  setup do
    @track = Track.create!(
      name: "Moscow Raceway",
      location: "Московская область, Волоколамский район",
      length_km: 3.955,
      turns: 15,
      source_key: "mrv"
    )

    @pilot = Pilot.create!(
      name: "Роман Русинов",
      car: "Porsche 911 GT3 Cup",
      pilot_class: "GT3"
    )

    @category = MarketCategory.create!(
      name: "Гоночные автомобили",
      slug: "race-cars",
      icon: "car"
    )

    @sim_slot = SimulatorSlot.create!(
      name: "Кокпит Pro 1 (Motion Rig + VR)",
      specs: "Direct Drive 25Nm, гидравлические педали Heusinkveld, 4DOF Motion",
      hourly_rate_rub: 2500,
      active: true
    )

    @sim_server = SimServer.create!(
      name: "TrackDays Hotlap MRV Sprint",
      server_ip: "185.220.101.5",
      http_port: 8081,
      tcp_port: 9600,
      track_name: "Moscow Raceway Sprint",
      track: @track,
      capacity: 24,
      online_drivers: 8,
      status: "online"
    )

    @sim_lap = SimLapRecord.create!(
      track: @track,
      pilot: @pilot,
      driver_name: "Роман Русинов",
      car_name: "Porsche 911 GT3 Cup",
      sim_game: "Assetto Corsa",
      lap_time: 98.450,
      sector_1: 29.120,
      sector_2: 34.800,
      sector_3: 34.530,
      tire_compound: "Soft Slick",
      record_date: Date.current
    )

    @sim_mod = SimMod.create!(
      title: "Moscow Raceway Laser Scan 2026",
      mod_type: "track",
      author: "Russian Sim Modding Team",
      version: "2.1",
      download_url: "https://trackdays.test/mods/mrv-laserscan.zip",
      description: "Точная лазерная копия Moscow Raceway для Assetto Corsa"
    )
  end

  test "complete market and simracing journey: view listings, create listing, view sim servers, leaderboard, mods, and book slot" do
    # 1. Marketplace catalog
    get market_url
    assert_response :success
    assert_includes response.body, "Гоночные автомобили"

    # 2. Post new listing
    get new_market_listing_url
    assert_response :success

    assert_difference("MarketListing.count", 1) do
      post market_url, params: {
        market_listing: {
          market_category_id: @category.id,
          pilot_id: @pilot.id,
          deal_type: "rent",
          title: "Аренда боевого Porsche Cayman GT4 Clubsport",
          description: "Готов к трек-дням и тайм-аттак. Обслужен, свежая резина, телеметрия в комплекте.",
          price: 180000,
          currency: "RUB",
          price_period: "per_trackday",
          city: "Москва",
          contact_name: "Роман",
          contact_phone: "+7 999 111-22-33",
          contact_telegram: "@rusinov_race"
        }
      }
    end

    created_listing = MarketListing.find_by(title: "Аренда боевого Porsche Cayman GT4 Clubsport")
    assert_not_nil created_listing
    assert_redirected_to market_listing_url(created_listing)
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Аренда боевого Porsche Cayman GT4 Clubsport"
    assert_includes response.body, "180 000"
    assert_includes response.body, "@rusinov_race"

    # 3. Simracing virtual servers
    get sim_servers_url
    assert_response :success
    assert_includes response.body, "TrackDays Hotlap MRV Sprint"

    # 4. Simracing leaderboard
    get sim_leaderboard_url
    assert_response :success
    assert_includes response.body, "Роман Русинов"
    assert_includes response.body, "Porsche 911 GT3 Cup"

    # 5. Simracing mods
    get sim_mods_url
    assert_response :success
    assert_includes response.body, "Moscow Raceway Laser Scan 2026"

    # 6. Simulator club booking
    get booking_url
    assert_response :success
    assert_includes response.body, "Кокпит Pro 1"

    # Book with instructor for 2 hours (2500 * 2 + 1000 * 2 = 7000 RUB)
    assert_difference("SimBooking.count", 1) do
      post booking_url, params: {
        sim_booking: {
          simulator_slot_id: @sim_slot.id,
          pilot_id: @pilot.id,
          customer_name: "Артем Смирнов",
          customer_phone: "+7 926 000-11-22",
          customer_email: "artem.smirnov@simclub.test",
          booking_date: (Date.current + 2.days).to_s,
          time_slot: "16:00 - 18:00",
          duration_hours: 2,
          with_instructor: true,
          notes: "Подготовка к этапу на Moscow Raceway"
        }
      }
    end

    booking = SimBooking.find_by(customer_name: "Артем Смирнов")
    assert_not_nil booking
    assert_equal 7000, booking.total_price_rub
    assert_redirected_to booking_url
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Ваша бронь симулятора успешно подтверждена"
  end
end
