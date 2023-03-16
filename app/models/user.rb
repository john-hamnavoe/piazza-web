class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :app_sessions, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_senstive: true}, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password
  validates :password, length: { minimum: 8, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }

  before_validation :strip_extraneous_spaces

  def self.create_app_session(email:, password:)
    return nil unless user = User.find_by(email: email.downcase)
  
    user.app_sessions.create if user.authenticate(password)
  end  

  def authenticate_app_session(app_session_id, token)
    app_sessions.find(app_session_id).authenticate_token(token)
    
    rescue ActiveRecord::RecordNotFound
    
    nil
  end  

  private

  def strip_extraneous_spaces
    self.name = name.strip if name
    self.email = email.strip if email
  end
end
