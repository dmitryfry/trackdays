require "test_helper"

class ChampionshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @championship = Championship.create!(
      name: "Тестовый Чемпионат",
      slug: "test-cup",
      category: "circuit"
    )
    @season = ChampionshipSeason.create!(
      championship: @championship,
      year: 2026,
      title: "Сезон 2026"
    )
  end

  test "should get index" do
    get championships_url
    assert_response :success
    assert_includes response.body, "Тестовый Чемпионат"
  end

  test "should show championship" do
    get championship_url(@championship.slug)
    assert_response :success
    assert_includes response.body, "Тестовый Чемпионат"
    assert_includes response.body, "Сезон 2026"
  end
end
