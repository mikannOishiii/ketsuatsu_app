FactoryBot.define do
  factory :post do
    title { "MyTitle" }
    content { "MyContent" }
    association :admin
  end
end
