require "test_helper"

class MediaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video = MediaVideo.create!(
      title: "Онборд на Moscow Raceway",
      category: "onboard",
      platform: "youtube",
      video_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    )
  end

  test "should get news" do
    get news_url
    assert_response :success
    assert_select "h1", text: /Новости/
  end

  test "should get videos" do
    get videos_url
    assert_response :success
    assert_includes response.body, "Онборд на Moscow Raceway"
  end
end
