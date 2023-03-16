require "test_helper"

class User::AuthenticationTest < ActiveSupport::TestCase
 
  test "password length must be between 8 and Active Model::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED" do
    user = User.new(name: "John", email: "john@example.com", password: "")
    assert_not user.valid?
    assert user.errors[:password].present?
    user.password = "password"
    assert user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    user.password = "a" * (max_length + 1)
    assert_not user.valid?
  end

  test "can create a session with email and correct password" do
    @app_session = User.create_app_session(
    email: "jerry@example.com",
    password: "password"
    )
    assert_not_nil @app_session
    assert_not_nil @app_session.token
  end

  test "cannot create a session with email and incorrect password" do
    @app_session = User.create_app_session(
    email: "jerry@example.com",
    password: "WRONG"
    )
    assert_nil @app_session
  end

  test "creating a session with non existent email returns nil" do
    @app_session = User.create_app_session(
    email: "whoami@example.com",
    password: "WRONG"
    )
    assert_nil @app_session
  end    

  test "can authenticate with a valid session id and token" do
    @user = users(:jerry)

    @app_session = @user.app_sessions.create
    assert_equal @app_session,
    @user.authenticate_app_session(@app_session.id, @app_session.token)
  end
    
  test "trying to authenticate with a token that doesn't exist returns false" do
    @user = users(:jerry)
    assert_not @user.authenticate_app_session(50, "token")
  end  
end