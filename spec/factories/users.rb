FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "テストユーザー" }
    password { "password1" }
    password_confirmation { "password1" }
    purpose { "テスト目的" }
  end
end
