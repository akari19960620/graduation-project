FactoryBot.define do
  factory :facility do
    monthly_fee_min { 1 }
    monthly_fee_max { 1 }
    capacity { 1 }
    room_type { "MyString" }
    care_level { 1 }
    services { "MyString" }
    features { "MyString" }
  end
end
