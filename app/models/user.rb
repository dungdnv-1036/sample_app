class User < ApplicationRecord
  attr_accessor :remember_token
  USERS_PARAMS = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
  length: {maximum: Settings.validate.user.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.validate.user.max_length_email},
    format: {with: Settings.validate.user.VALID_EMAIL_REGEX},
    uniqueness: true

  has_secure_password

  before_save :downcase_email

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update :remember_digest, User.digest remember_token
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update :remember_digest, nil
  end

  private

  def downcase_email
    self.email.downcase!
  end
end
