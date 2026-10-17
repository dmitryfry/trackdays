require "test_helper"

class MarketControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = MarketCategory.create!(name: "Гоночные авто", slug: "race-cars-test")
    @listing = MarketListing.create!(
      market_category: @category,
      deal_type: "sale",
      title: "BMW M3 Track tool test",
      description: "Готовый корч под регламент",
      price: 3500000,
      city: "Москва",
      contact_name: "Гонщик",
      contact_phone: "+79991112233"
    )
  end

  test "should get market index" do
    get market_path
    assert_response :success
    assert_select "h1", /Гоночный Маркетплейс/
    assert_includes response.body, "BMW M3 Track tool test"
  end

  test "should filter listings by deal_type" do
    rent_listing = MarketListing.create!(
      market_category: @category,
      deal_type: "rent",
      title: "Аренда Radical SR3",
      description: "Аренда на трек-день",
      price: 150000,
      city: "Сочи",
      contact_name: "Сервис"
    )

    get market_path(deal_type: "rent")
    assert_response :success
    assert_includes response.body, "Аренда Radical SR3"
    assert_not_includes response.body, "BMW M3 Track tool test"
  end

  test "should show listing details" do
    get market_listing_path(@listing)
    assert_response :success
    assert_includes response.body, "BMW M3 Track tool test"
    assert_includes response.body, "Контакты продавца"
  end

  test "should get new listing form" do
    get new_market_listing_path
    assert_response :success
    assert_select "form"
  end

  test "should create market listing" do
    assert_difference("MarketListing.count", 1) do
      post market_path, params: {
        market_listing: {
          market_category_id: @category.id,
          deal_type: "sale",
          title: "Porsche Cayman GT4 Clubsport",
          description: "Пробег 5000 км, без ДТП, готов к гонкам",
          price: 14000000,
          city: "Санкт-Петербург",
          contact_name: "Алексей",
          contact_phone: "+79001234567"
        }
      }
    end

    new_listing = MarketListing.last
    assert_redirected_to market_listing_path(new_listing)
    follow_redirect!
    assert_includes response.body, "Porsche Cayman GT4 Clubsport"
  end
end
