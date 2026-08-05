FactoryBot.define do
  factory :facility do
    sequence(:name) { |n| "テスト施設#{n}" }
    facility_type { "特別養護老人ホーム" }
    address { "神奈川県横浜市鶴見区獅子ケ谷2-15-18" }
    sequence(:phone) { |n| "045-583-#{1000 + n}" }  # ← ユニークな電話番号を生成
    monthly_fee_min { 30000 }
    monthly_fee_max { nil }
    image { "https://via.placeholder.com/300x200?text=Facility" }
    capacity { 80 }
    room_type { "1人部屋、2人部屋、4人部屋" }
    care_level { 1 }
    services { "介護サービス、医療サービス" }
    features { "ご利用者の立場に立ち、自立した生活を営めるよう支援することを心がけ、サービス提供に努めている" }
    cost_score { 4 }
    medical_score { 4 }
    facility_score { 3 }
    website_url { nil }
  end
end
