require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should return html search page" do
    get search_url(q: "Moscow")
    assert_response :success
  end

  test "should return json omnisearch results" do
    get search_url(q: "Moscow"), headers: { "Accept" => "application/json" }
    assert_response :success
    json = JSON.parse(response.body)
    assert json.key?("results")
  end
end
