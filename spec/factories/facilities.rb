FactoryBot.define do
  factory :facility do
    sequence(:name) { |n| "施設#{n}" }
    facility_type { "介護付き有料老人ホーム" }
    sequence(:address) { |n| "神奈川県横浜市中区本牧原#{n}-11" }
    phone { "0037-630-53267" }
    monthly_fee_min { 100000 }
    monthly_fee_max { 300000 }
    image { "https://via.placeholder.com/300x200?text=Facility" }
    capacity { "100名" }
    room_type { "個室" }
    care_level { "要介護1～5" }
    services { "医療サービス、介護サービス、個別リハビリ等" }
    features { "充実した介護体制と設備" }
    cost_score { 3 }
    medical_score { 3 }
    facility_score { 3 }
    website_url { nil }

    # コスト重視の施設
    trait :cost_focused do
      cost_score { 5 }
      medical_score { 2 }
      facility_score { 2 }
      monthly_fee_min { 50000 }
      monthly_fee_max { 100000 }
    end

    # 施設重視の施設
    trait :facility_focused do
      cost_score { 2 }
      medical_score { 2 }
      facility_score { 5 }
      features { "最新設備と充実した娯楽施設" }
    end

    # 医療重視の施設
    trait :medical_focused do
      cost_score { 2 }
      medical_score { 5 }
      facility_score { 2 }
      services { "24時間看護師常駐、医療機関隣接" }
    end
  end
end
