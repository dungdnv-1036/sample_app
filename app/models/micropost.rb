class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user

  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.validate.micropost.max_length}
  validates :image,
            content_type: {in: Settings.validate.micropost.type,
                           message: I18n.t("micropost.image_type_validate")},
            size: {less_than: Settings.micropost.image_size.megabytes,
                   message: I18n.t("micropost.image_size_validate")}

  scope :order_by_desc, ->{order created_at: :desc }
  scope :micropost_feed, ->(user_id){where user_id: user_id }

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_limit
  end
end
