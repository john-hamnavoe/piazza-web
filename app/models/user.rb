class User < ApplicationRecord
  include Authentication

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  validates :name, presence: true
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { case_sensitive: false }

  before_validation :strip_extraneous_spaces

  private

  def strip_extraneous_spaces
    self.name = name.strip if name
    self.email = email.strip if email
  end
end
