FactoryBot.define do
  factory :diagnosis do
    session_id { "MyString" }
    diagnosis_result { nil }
    status { 1 }
    completed_at { "2026-08-03 06:49:33" }
  end
end
