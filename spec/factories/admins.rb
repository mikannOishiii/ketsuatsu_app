FactoryBot.define do
  factory :admin do
    account_name { |n| "adminuser#{n}" }
    email { |n| "admin#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }

    trait :invalid do
      account_name { "" }
    end
  end
end
