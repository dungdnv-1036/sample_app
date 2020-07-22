class User < ApplicationRecord

  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
  length: {maximum: Settings.validate.user.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.validate.user.max_length_email},
    format: {with: Settings.validate.user.VALID_EMAIL_REGEX},
    uniqueness: true

  has_secure_password

  before_save :downcase_email

  private

  def downcase_email
    self.email.downcase!
  end
end
