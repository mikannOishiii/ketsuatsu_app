class Post < ApplicationRecord
  belongs_to :admin
  scope :desc, -> { order("posts.created_at DESC") }
  validates :admin_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 1000 }
end
