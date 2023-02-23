class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_senstive: true}, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password
  validates :password, length: { minimum: 8, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }

  before_validation :strip_extraneous_spaces

  private

  def strip_extraneous_spaces
    self.name = name.strip if name
    self.email = email.strip if email
  end
end
