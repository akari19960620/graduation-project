FactoryBot.define do
  factory :diagnosis do
    sequence(:session_id) { |n| "session_#{n}_#{SecureRandom.hex(8)}" }
    status { :in_progress }

    trait :completed do
      status { :completed }
      association :diagnosis_result
    end
  end
end
