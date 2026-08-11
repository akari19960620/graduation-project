FactoryBot.define do
  factory :diagnosis_question do
    sequence(:question_text) { |n| "診断質問#{n}" }
    question_type { "choice" }
    weight_category { "cost_vs_facility" }
    sequence(:display_order)

    # 選択肢付きの質問を作成するトレイト
    trait :with_options do
      after(:create) do |question|
        create(:diagnosis_option, :cost_focused, diagnosis_question: question, display_order: 1)
        create(:diagnosis_option, :facility_focused, diagnosis_question: question, display_order: 2)
      end
    end

    # シードデータと同じ5つの質問を作成するトレイト
    trait :complete_set do
      # このトレイトは後述の方法で使用します
    end
  end
end
