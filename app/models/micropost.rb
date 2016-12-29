class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  scope :of_user, -> (user_id) do
    where("user_id IN (
      SELECT followed_id FROM relationships
      WHERE  follower_id = :user_id)
      OR user_id = :user_id", user_id: user_id)
    .order(created_at: :desc)
  end

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, t(:image_size_validate_mess))
    end
  end

end
