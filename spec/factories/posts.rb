FactoryBot.define do
  factory :post do
    title { "MyTitle" }
    content { "MyContent" }
    association :admin

    trait :invalid do
      title { "" }
    end
  end
end
