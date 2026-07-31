FactoryBot.define do
  factory :diagnosis_option do
    diagnosis_question { nil }
    option_text { "MyString" }
    weight_value { 1 }
    display_order { 1 }
  end
end
