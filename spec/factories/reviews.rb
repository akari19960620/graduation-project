FactoryBot.define do
  factory :review do
    association :user
    association :facility
    cost_rating { 3 }
    facility_rating { 3 }
    medical_rating { 3 }
    comment { "MyText" }
  end
end
