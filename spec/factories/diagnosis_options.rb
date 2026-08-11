FactoryBot.define do
  factory :diagnosis_option do
    sequence(:option_text) { |n| "選択肢#{n}" }
    weight_value { 20 }
    weight_category { "cost" }
    sequence(:display_order)
    association :diagnosis_question

    # コスト重視の選択肢
    trait :cost_focused do
      option_text { "料金が安い方を重視する" }
      weight_category { "cost" }
      weight_value { 20 }
    end

    # 施設重視の選択肢
    trait :facility_focused do
      option_text { "施設の充実度を重視する" }
      weight_category { "facility" }
      weight_value { 20 }
    end

    # 医療重視の選択肢
    trait :medical_focused do
      option_text { "医療体制を重視する" }
      weight_category { "medical" }
      weight_value { 20 }
    end
  end
end
