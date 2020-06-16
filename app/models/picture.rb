class Picture < ApplicationRecord
  belongs_to :post
  mount_uploader :name, PictureUploader
  validates :name, presence: true
  validate :picture_size

  private

  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    if name.size > 1.megabytes
      errors.add(:name, "1MB以上のファイルはアップロードできません。")
    end
  end
end
