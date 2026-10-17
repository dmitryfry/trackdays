require "test_helper"

class BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Блогер Гонщик",
      email: "blogger@example.com",
      password: "password123",
      role: "pilot"
    )
    @article = Article.create!(
      user: @user,
      title: "Как настроить сход-развал",
      category: "setup",
      summary: "Практическое руководство",
      content: "Текст статьи про развал и схождение колес."
    )
  end

  test "should get index" do
    get blogs_url
    assert_response :success
    assert_select "h1", text: /Блоги сообщества и статьи/
    assert_includes response.body, "Как настроить сход-развал"
  end

  test "should show article" do
    get blog_post_url(@article.slug)
    assert_response :success
    assert_includes response.body, "Как настроить сход-развал"
    assert_includes response.body, "Блогер Гонщик"
  end

  test "should require login for new article" do
    get new_blog_post_url
    assert_redirected_to login_url
  end

  test "should allow logged in user to post article" do
    post login_url, params: { email: @user.email, password: "password123" }
    assert_redirected_to root_url

    assert_difference("Article.count", 1) do
      post blogs_url, params: {
        article: {
          title: "Новый гайд по торможению",
          category: "guide",
          summary: "Торможение трейлбрейкинг",
          content: "Техника позднего трейлбрейкинга на треке."
        }
      }
    end
    assert_response :redirect
  end
end
