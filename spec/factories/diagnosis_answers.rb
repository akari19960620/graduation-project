FactoryBot.define do
  factory :diagnosis_answer do
    association :diagnosis
    association :diagnosis_question
    association :diagnosis_option
  end
end
