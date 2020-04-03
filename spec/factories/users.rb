FactoryBot.define do
  factory :user do
    sequence(:account_name) { |n| "Example User #{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "foobar" }
    accepted { true }
  end
end
