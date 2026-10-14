require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = Team.create!(
      name: "Super Racing Team",
      slug: "super-racing-team",
      city: "Москва",
      points: 150
    )
  end

  test "should show team" do
    get team_url(@team.slug)
    assert_response :success
    assert_includes response.body, "Super Racing Team"
    assert_includes response.body, "Москва"
  end
end
