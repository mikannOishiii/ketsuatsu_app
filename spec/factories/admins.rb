FactoryBot.define do
  factory :admin do
    account_name { "adminuser" }
    email { |n| "admin@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }

    trait :invalid do
      account_name { "" }
    end
  end
end
