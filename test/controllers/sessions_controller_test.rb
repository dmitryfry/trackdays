require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Дмитрий Гонщик",
      email: "pilot@example.com",
      password: "secretpassword",
      role: "pilot"
    )
  end

  test "should get login page" do
    get login_url
    assert_response :success
  end

  test "should login successfully with correct credentials" do
    post login_url, params: { email: "pilot@example.com", password: "secretpassword" }
    assert_redirected_to root_url
    assert_equal @user.id, session[:user_id]
  end

  test "should reject invalid credentials" do
    post login_url, params: { email: "pilot@example.com", password: "wrongpassword" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should logout" do
    post login_url, params: { email: "pilot@example.com", password: "secretpassword" }
    assert_equal @user.id, session[:user_id]

    delete logout_url
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
