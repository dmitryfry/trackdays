require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      name: "Тестовый Автор",
      email: "author@example.com",
      password: "password123",
      role: "pilot"
    )
  end

  test "should generate unique slug before validation" do
    article = Article.new(
      user: @user,
      title: "Moscow Raceway Trackday",
      category: "report",
      content: "Подробный отчет о выезде на трек."
    )
    assert article.valid?
    assert article.slug.present?
    assert_includes article.slug, "moscow-raceway-trackday"
  end

  test "should require valid category" do
    article = Article.new(
      user: @user,
      title: "Title",
      category: "invalid_category",
      content: "Content"
    )
    assert_not article.valid?
  end
end
