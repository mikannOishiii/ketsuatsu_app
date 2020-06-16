FactoryBot.define do
  factory :picture do
    name { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/testfile.png'), 'spec/support/testfile.png') }
    association :post
  end
end
