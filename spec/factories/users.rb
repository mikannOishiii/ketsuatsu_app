FactoryBot.define do
  factory :user do
    sequence(:account_name) { |n| "Example User #{n}" }
    email { "test@example.com" }
    password { "foobar" }
    accepted { true }
  end
end
