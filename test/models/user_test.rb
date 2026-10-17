require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    user = User.new(
      name: "Алексей Смирнов",
      email: "alex@example.com",
      password: "password123",
      password_confirmation: "password123",
      role: "pilot"
    )
    assert user.valid?
  end

  test "should require unique lowercase email" do
    User.create!(
      name: "Pilot 1",
      email: "test@example.com",
      password: "password123",
      role: "pilot"
    )
    dup = User.new(
      name: "Pilot 2",
      email: "TEST@EXAMPLE.COM",
      password: "password123",
      role: "pilot"
    )
    assert_not dup.valid?
  end

  test "should reject invalid role" do
    user = User.new(
      name: "Invalid Role",
      email: "role@example.com",
      password: "password123",
      role: "superhero"
    )
    assert_not user.valid?
  end
end
