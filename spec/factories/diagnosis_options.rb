FactoryBot.define do
  factory :diagnosis_option do
    sequence(:option_text) { |n| "選択肢#{n}" } # 選択肢文をユニークにする
    weight_value { 20 }
    weight_category { [ 'cost', 'medical', 'facility' ].sample }
    sequence(:display_order) { |n| n }
    association :diagnosis_question # 質問と関連付け
  end
end
