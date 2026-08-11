FactoryBot.define do
  factory :facility_match do
    association :diagnosis_result
    association :facility
  end
end
