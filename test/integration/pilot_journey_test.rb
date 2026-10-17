require "test_helper"

class PilotJourneyTest < ActionDispatch::IntegrationTest
  test "full pilot journey: registration, login, garage car, logbook, article, comment, omnisearch" do
    # 1. Registration
    get register_url
    assert_response :success

    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          name: "Максим Гончаров",
          email: "m.goncharov@trackdays.test",
          password: "trackdaypassword123",
          password_confirmation: "trackdaypassword123",
          role: "pilot",
          telegram_username: "@mgoncharov"
        }
      }
    end
    assert_redirected_to profile_url
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Максим Гончаров"

    created_user = User.find_by(email: "m.goncharov@trackdays.test")
    assert_not_nil created_user
    assert_equal "pilot", created_user.role

    # 2. Add Car to Garage
    get new_garage_car_url
    assert_response :success

    assert_difference("GarageCar.count", 1) do
      post garage_url, params: {
        garage_car: {
          make: "Porsche",
          model: "Cayman GT4 Clubsport",
          year: 2021,
          power_hp: 425,
          mass_kg: 1320,
          car_class: "Super-Sport",
          drivetrain: "RWD",
          specs: "KW V3 Suspension, PFC Brakes, Michelin Cup 2R"
        }
      }
    end

    car = GarageCar.find_by(model: "Cayman GT4 Clubsport")
    assert_not_nil car
    assert_redirected_to garage_car_url(car)
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Cayman GT4 Clubsport"
    assert_includes response.body, "KW V3 Suspension"

    # 3. Add Logbook entry to car
    assert_difference("LogbookEntry.count", 1) do
      post create_logbook_entry_url(car), params: {
        logbook_entry: {
          title: "Первый выезд на Moscow Raceway",
          content: "Проверили углы сход-развала и давление в сликах. Время 1:44.200 стабильно.",
          date: Date.current
        }
      }
    end
    assert_redirected_to garage_car_url(car)
    follow_redirect!
    assert_includes response.body, "Первый выезд на Moscow Raceway"

    # 4. Write blog post / race report
    get new_blog_post_url
    assert_response :success

    assert_difference("Article.count", 1) do
      post blogs_url, params: {
        article: {
          title: "Отчет: Настройка Cayman GT4 под трек-день",
          category: "setup",
          summary: "Поведение шасси на торможениях и подбор жесткости стабилизаторов",
          content: "В этой статье разберем, как повлияло изменение сход-развала на время круга."
        }
      }
    end

    article = Article.find_by(title: "Отчет: Настройка Cayman GT4 под трек-день")
    assert_not_nil article
    assert_redirected_to blog_post_url(article.slug)
    follow_redirect!
    assert_response :success
    assert_includes response.body, "Отчет: Настройка Cayman GT4 под трек-день"

    # 5. Add comment to article
    assert_difference("Comment.count", 1) do
      post blog_post_comments_url(article.slug), params: {
        comment: {
          body: "Отличный отчет! Какое давление в горячем состоянии держали?"
        }
      }
    end
    assert_redirected_to blog_post_url(article.slug)
    follow_redirect!
    assert_includes response.body, "Отличный отчет! Какое давление в горячем состоянии держали?"

    # 6. Global Omnisearch verification
    get search_url(q: "Cayman"), headers: { "Accept" => "application/json" }
    assert_response :success
    json_response = JSON.parse(response.body)
    titles = json_response["results"].map { |r| r["title"] }
    assert titles.any? { |t| t.include?("Cayman GT4") }, "Omnisearch should find the newly created car or article"
  end
end
