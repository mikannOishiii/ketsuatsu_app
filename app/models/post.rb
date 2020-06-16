class Post < ApplicationRecord
  acts_as_readable on: :created_at
  belongs_to :admin
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy: true
  scope :desc, -> { order("posts.created_at DESC") }
  validates :admin_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 1000 }
  enum status: { :draft => 0, :published => 1, :unpublished => 2 }
end
