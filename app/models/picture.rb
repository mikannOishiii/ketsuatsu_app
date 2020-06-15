class Picture < ApplicationRecord
  belongs_to :post
  mount_uploader :name, PictureUploader
end
