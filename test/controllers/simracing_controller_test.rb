require "test_helper"

class SimracingControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = tracks(:one)
    @server = SimServer.create!(
      track: @track,
      name: "TrackDays AC Test Server",
      sim_game: "Assetto Corsa",
      server_ip: "127.0.0.1",
      http_port: 8081,
      tcp_port: 9600,
      track_name: "moscow_raceway",
      capacity: 24,
      online_drivers: 4,
      status: "online"
    )
    @mod = SimMod.create!(
      title: "Moscow Raceway Laser Scan",
      mod_type: "track",
      download_url: "https://example.com/mr.zip"
    )
  end

  test "should get servers page" do
    get sim_servers_url
    assert_response :success
    assert_select "h1", text: /Симрейсинг Хаб: Серверы/
    assert_select "h3", text: @server.name
  end

  test "should get leaderboard page" do
    get sim_leaderboard_url
    assert_response :success
    assert_select "h1", text: /Лидерборд виртуальных времен/
  end

  test "should get mods page" do
    get sim_mods_url
    assert_response :success
    assert_select "h1", text: /Каталог гоночных модификаций/
    assert_select "h3", text: @mod.title
  end

  test "should filter mods by type" do
    get sim_mods_url(type: "track")
    assert_response :success
    assert_select "h3", text: @mod.title
  end
end
