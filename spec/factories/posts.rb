FactoryBot.define do
  factory :post do
    title { "MyTitle" }
    content { "MyContent" }
    status { "published" }
    association :admin

    trait :invalid do
      title { "" }
    end
  end

  factory :post_with_picture do
    title { "MyTitle" }
    content { "MyContent" }
    status { "published" }
    association :admin

    after(:create) do |post|
      create(:picture, post: post)
    end
  end
end
