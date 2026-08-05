FactoryBot.define do
  factory :diagnosis_question do
    sequence(:question_text) { |n| "診断質問#{n}" } # 質問文をユニークにする
    question_type { 'choice' }
    sequence(:display_order) { |n| n }
  end
end
