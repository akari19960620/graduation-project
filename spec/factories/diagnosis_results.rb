FactoryBot.define do
  factory :diagnosis_result do
    category { "cost" }
    result_title { "コスト重視タイプ" }
    result_description { "あなたは費用を重視するタイプです。" }

    # 施設付きの診断結果
    trait :with_facilities do
      after(:create) do |result|
        facilities = create_list(:facility, 3, cost_score: 5)
        facilities.each do |facility|
          create(:facility_match, diagnosis_result: result, facility: facility)
        end
      end
    end

    # 施設重視タイプ
    trait :facility_focused do
      category { "facility" }
      result_title { "施設重視タイプ" }
      result_description { "あなたは施設の充実度を重視するタイプです。" }
    end

    # 医療重視タイプ
    trait :medical_focused do
      category { "medical" }
      result_title { "医療・ケア重視タイプ" }
      result_description { "あなたは医療・ケアの質を重視するタイプです。" }
    end
  end
end
