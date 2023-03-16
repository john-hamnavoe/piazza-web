require "test_helper"

class UserTest < ActiveSupport::TestCase

  test "requires a name " do 
    user = User.new(name: "", email: "john@example.com", password: "password")
    assert_not user.valid?
    assert user.errors[:name].present?
    user.name = "John"
    assert user.valid?
  end

  test "requires a valid email" do
    user = User.new(name: "John", email: "", password: "password")
    assert_not user.valid?
    assert user.errors[:email].present?
    user.email = "invalid"
    assert_not user.valid?
    assert user.errors[:email].present?
    user.email = "john@example.com"
    assert user.valid?
  end 

  test "requires a unique email" do
    existing_user = User.create(name: "John", email: "john@example.com", password: "password")
    assert existing_user.persisted?
    user = User.new(name: "John", email: "john@example.com")
    assert_not user.valid?
    assert user.errors[:email].present?
  end

  test "name and email are stripped of whitespace" do
    user = User.create(name: " John ", email: " john@example.com ")
    assert_equal "John", user.name
    assert_equal "john@example.com", user.email
  end

end
