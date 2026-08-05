# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
unless Rails.env.test?
  # 既存のデータを削除する（開発環境のみ）※削除の順番に注意！
  if Rails.env.development?
    FacilityMatch.destroy_all  # 中間テーブル削除を追加
    DiagnosisOption.destroy_all  # 子テーブル削除
    DiagnosisQuestion.destroy_all  # 親テーブル削除
    DiagnosisResult.destroy_all # 診断結果削除
    Facility.destroy_all  # 施設データ削除
  end


  # 施設データの投入
  Facility.create!(
    name: "青葉ヒルズ",
    facility_type: "特別養護老人ホーム",
    address: "神奈川県横浜市青葉区鴨志田町1260",
    phone: "0037-630-21227",
    monthly_fee_min: 38700,
    monthly_fee_max: 162600,
    image: "https://via.placeholder.com/300x200?text=Facility+A",
    capacity: "140名",
    room_type: "ユニット型個室",
    care_level: "要介護1~5（要介護1、2は特例入所要件該当者のみ）",
    services: "医療サービス、介護サービス、個別リハビリ等全般（詳細はホームページを参照ください）",
    features: "自然に恵まれた好環境、都心から近い好立地で居住エリアは10人単位のユニット。クラブ活動や季節ごとの行事の他、機能訓練や音楽・美術プログラムなど青葉ヒルズならではのアクティビティが日常生活の一部として定着している",
    cost_score: 4,
    medical_score: 3.5,
    facility_score: 4,
    website_url: nil
  )

  Facility.create!(
    name: "中銀ライフケア横浜",
    facility_type: "シニア向け分譲マンション",
    address: "神奈川県横浜市都筑区新栄町14-1中銀ライフケア横浜（港北）",
    phone: "0037-630-77625",
    monthly_fee_min: 72100,
    monthly_fee_max: 81900,
    image: "https://via.placeholder.com/300x200?text=Facility+B",
    capacity: "443室",
    room_type: "個室",
    care_level: "入居条件：自立（介護認定を受けていないこと）",
    services: "24時間看護師常駐で健康管理のお手伝いや、施設責任者やスタッフが生活全般のご相談に対応。",
    features: "所有権分譲方式の売却もでき、相続財産にもなる個人資産。アクセスの良い立地で栄養バランスの整った温かい食事、喫茶・大浴場・麻雀室など充実の共用施設もある。（入居時費用あり）",
    cost_score: 4,
    medical_score: 3.5,
    facility_score: 4.5,
    website_url: nil
  )

  Facility.create!(
    name: "すいとぴー本牧三渓園",
    facility_type: "介護付き有料老人ホーム",
    address: "神奈川県横浜市中区本牧原1-11",
    phone: "0037-630-53267",
    monthly_fee_min: 250600,
    monthly_fee_max: 394200,
    image: "https://via.placeholder.com/300x200?text=Facility+C",
    capacity: "-",
    room_type: "個室",
    care_level: "要介護1～5",
    services: "医療サービス、介護サービス、個別リハビリ等全般（詳細はホームページを参照ください）",
    features: "豊かな緑に囲まれた環境と眺望を備えた居住空間で上質な暮らしを実現。また、国の基準を上回る2対1の手厚い介護体制と建物内にクリニックがあり看護師が24時間常駐している",
    cost_score: 2,
    medical_score: 4,
    facility_score: 4,
    website_url: nil
  )

  Facility.create!(
    name: "横浜エデンの園",
    facility_type: "介護付き有料老人ホーム",
    address: "神奈川県横浜市保土ケ谷区岩井町207",
    phone: "0037-630-93158",
    monthly_fee_min: 204200,
    monthly_fee_max: 575100,
    image: "https://via.placeholder.com/300x200?text=Facility+D",
    capacity: "-",
    room_type: "個室",
    care_level: "要支援1～2、要介護1～5",
    services: "介護サービス、個別リハビリ等（協力医療機関病院隣接）",
    features: "当事業団が設置・運営する協力医療機関・聖隷横浜病院に隣接しており、医住近接の環境を実現。看護師24時間常駐。ご入居者の嚥下・咀嚼レベルに合わせた食事形態や治療食にも対応（入居時費用あり）",
    cost_score: 2,
    medical_score: 4.5,
    facility_score: 4,
    website_url: nil
  )

  Facility.create!(
    name: "ALSOKケアホーム横浜港南台",
    facility_type: "介護付き有料老人ホーム",
    address: "神奈川県横浜市港南区日野中央三丁目15番2号",
    phone: "0037-630-83746",
    monthly_fee_min: 215000,
    monthly_fee_max: nil,
    image: "https://via.placeholder.com/300x200?text=Facility+E",
    capacity: "-",
    room_type: "個室",
    care_level: "要介護1～5",
    services: "要問合せ",
    features: "2026年2月新築オープン。館内Wi-Fi完備。プライバシーに配慮した見守りセンサーや介護記録システムを導入し、安全安心を最優先に、快適な住環境を提供している（入居時費用あり）",
    cost_score: 3,
    medical_score: nil,
    facility_score: 4,
    website_url: nil
  )

  Facility.create!(
    name: "ALSOKグループホーム横浜上飯田Ⅱ",
    facility_type: "グループホーム",
    address: "神奈川県横浜市泉区上飯田町3795-9",
    phone: "0037-630-92331",
    monthly_fee_min: 163100,
    monthly_fee_max: nil,
    image: "https://via.placeholder.com/300x200?text=Facility+F",
    capacity: "18名",
    room_type: "個室",
    care_level: "要支援2、要介護1～5（その他条件あり）",
    services: "介護サービス、訪問診療、訪問歯科診療、訪問リハビリ等",
    features: "ＡＬＳＯＫグループならではのコンテンツや独自の運動プログラムを積極的に導入し健康増進につとめています",
    cost_score: 4,
    medical_score: 2.5,
    facility_score: 3,
    website_url: nil
  )

  Facility.create!(
    name: "プレゼンス野庭",
    facility_type: "グループホーム",
    address: "神奈川県横浜市港南区野庭町675-20",
    phone: "0037-630-01444",
    monthly_fee_min: 158000,
    monthly_fee_max: nil,
    image: "https://via.placeholder.com/300x200?text=Facility+G",
    capacity: "-",
    room_type: "個室",
    care_level: "要介護1～5（認知症診断必須）",
    services: "介護サービス（自立支援）",
    features: "地域との関わりや屋外・外出イベント等の季節に合ったイベントを開催（入居時費用あり）",
    cost_score: 4,
    medical_score: 2,
    facility_score: 3.5,
    website_url: nil
  )

  Facility.create!(
    name: "フォーシーズンズヴィラそよかぜ",
    facility_type: "ケアハウス",
    address: "神奈川県横浜市緑区三保町880",
    phone: "0037-630-65419",
    monthly_fee_min: 175000,
    monthly_fee_max: 229700,
    image: "https://via.placeholder.com/300x200?text=Facility+H",
    capacity: "100名",
    room_type: "個室",
    care_level: "要介護1～5",
    services: "介護サービス、医療サービス（日中のみ看護師）、往診体制あり、保険外サービスあり",
    features: "完全個室ユニット型、２：１の手厚い介護人員配置、季節感を感じられる毎月のレクリエーションの実施（入居時費用あり）",
    cost_score: 3,
    medical_score: 3.5,
    facility_score: 3.5,
    website_url: nil
  )

  Facility.create!(
    name: "ケアハウスゆうあい",
    facility_type: "ケアハウス",
    address: "神奈川県横浜市戸塚区川上町84-1",
    phone: "",
    monthly_fee_min: 104700,
    monthly_fee_max: 153900,
    image: "https://via.placeholder.com/300x200?text=Facility+I",
    capacity: "139名",
    room_type: "個室",
    care_level: "自立、要支援1～2、要介護1～5",
    services: "介護サービス、医療サービス",
    features: "一人一人の状態に合った形で包括的な介護サービスの提供を受けることが出来、季節ごとの行事や同施設内の学園祭にも自由に参加できる（入居時費用あり）",
    cost_score: 4,
    medical_score: 3,
    facility_score: 3.5,
    website_url: nil
  )

  Facility.create!(
    name: "やまゆりホーム",
    facility_type: "特別養護老人ホーム",
    address: "神奈川県横浜市鶴見区獅子ケ谷2-15-18",
    phone: "045-583-1833",
    monthly_fee_min: nil,
    monthly_fee_max: nil,
    image: "https://via.placeholder.com/300x200?text=Facility+J",
    capacity: "80名",
    room_type: "1人部屋、2人部屋、4人部屋",
    care_level: "要介護3～5",
    services: "介護サービス、医療サービス",
    features: "ご利用者の立場に立ち、自立した生活を営めるよう支援することを心がけ、サービス提供に努めている",
    cost_score: nil,
    medical_score: 4,
    facility_score: 3,
    website_url: nil
  )


  # 診断質問の初期データ投入

  # 質問１
  question1 = DiagnosisQuestion.create!(
    question_text: '駅近で家族が訪問しやすいが料金が高い施設と、郊外で料金が安い施設、どちらを選びますか？',
    question_type: 'choice',
    weight_category: 'cost_vs_facility',
    display_order: 1
  )

  question1.diagnosis_options.create!([
    { option_text: '駅近で家族が訪問しやすい方を重視する', weight_value: 20, weight_category: 'facility', display_order: 1 },
    { option_text: '料金が安い方を重視する', weight_value: 20, weight_category: 'cost', display_order: 2 }
  ])


  # 質問２
  question2 = DiagnosisQuestion.create!(
    question_text: '設備が新しくきれいだが料金が高い施設と、設備は古いが料金が安い施設どちらを選びますか？',
    question_type: 'choice',
    weight_category: 'facility_vs_cost',
    display_order: 2
  )

  question2.diagnosis_options.create!([
    { option_text: '設備が新しい方を重視する', weight_value: 20, weight_category: 'facility', display_order: 1 },
    { option_text: '料金が安い方を重視する', weight_value: 20, weight_category: 'cost', display_order: 2 }
  ])

  # 質問３
  question3 = DiagnosisQuestion.create!(
    question_text: '庭園や散歩スペースが広く自然豊かな施設と、庭園は狭いが医療機関が隣接している施設、どちらを選びますか？',
    question_type: 'choice',
    weight_category: 'facility_vs_medical',
    display_order: 3
  )

  question3.diagnosis_options.create!([
    { option_text: '自然豊かな施設を重視する', weight_value: 20, weight_category: 'facility', display_order: 1 },
    { option_text: '医療機関が隣接している施設を重視する', weight_value: 20, weight_category: 'medical', display_order: 2 }
  ])

  # 質問４
  question4 = DiagnosisQuestion.create!(
    question_text: '看護師が24時間常駐しているが料金が高い施設と、看護師は日中のみだが料金が安い施設、どちらを選びますか？',
    question_type: 'choice',
    weight_category: 'medical_vs_cost',
    display_order: 4
  )

  question4.diagnosis_options.create!([
    { option_text: '看護師が24時間常駐している方を重視する', weight_value: 20, weight_category: 'medical', display_order: 1 },
    { option_text: '料金が安い方を重視する', weight_value: 20, weight_category: 'cost', display_order: 2 }
  ])

  # 質問５
  question5 = DiagnosisQuestion.create!(
    question_text: '娯楽設備が充実している施設と、娯楽設備は少ないが看取りケアや終末期医療に対応している施設、どちらを選びますか？',
    question_type: 'choice',
    weight_category: 'facility_vs_medical',
    display_order: 5
  )

  question5.diagnosis_options.create!([
    { option_text: '娯楽施設が充実している施設を重視する', weight_value: 20, weight_category: 'facility', display_order: 1 },
    { option_text: '看取りケアや終末期に対応している施設を重視する', weight_value: 20, weight_category: 'medical', display_order: 2 }
  ])

  puts "診断質問データを作成しました！"
  puts "質問数: #{DiagnosisQuestion.count}"
  puts "選択肢数: #{DiagnosisOption.count}"

  # 診断結果を作成
  DiagnosisResult.create!([
    {
      category: 'cost',
      result_title: 'コスト重視タイプ',
      result_description: 'あなたは費用を重視するタイプです。経済的な負担を抑えることを優先する傾向があります。施設選びでは、まず費用面を確認し、予算内で最適な選択肢を探すことをおすすめします。'
    },
    {
      category: 'facility',
      result_title: '施設重視タイプ',
      result_description: 'あなたは施設の充実度を重視するタイプです。快適な環境で過ごすことを優先する傾向があります。施設の設備や雰囲気、アクセスの良さなどを重視して選ぶと良いでしょう。'
    },
    {
      category: 'medical',
      result_title: '医療・ケア重視タイプ',
      result_description: 'あなたは医療・ケアの質を重視するタイプです。専門的なサポートを受けることを優先する傾向があります。医療体制やスタッフの質、ケア内容の充実度を重視して選ぶことをおすすめします。'
    }
  ])

  puts "診断結果のシードデータを作成しました！"
  puts "診断結果テンプレート数: #{DiagnosisResult.count}"

  # 診断結果を取得
  cost_result = DiagnosisResult.find_by!(category: 'cost')
  facility_result = DiagnosisResult.find_by!(category: 'facility')
  medical_result = DiagnosisResult.find_by!(category: 'medical')

  # コスト重視タイプ: cost_score が高い施設を紐付け
  cost_facilities = Facility.where.not(cost_score: nil).order(cost_score: :desc).limit(5)
  cost_result.facilities << cost_facilities

  # 施設重視タイプ: facility_score が高い施設を紐付け
  facility_facilities = Facility.where.not(facility_score: nil).order(facility_score: :desc).limit(5)
  facility_result.facilities << facility_facilities

  # 医療・ケア重視タイプ: medical_score が高い施設を紐付け
  medical_facilities = Facility.where.not(medical_score: nil).order(medical_score: :desc).limit(5)
  medical_result.facilities << medical_facilities

  puts "中間テーブルのデータを作成しました！"
  puts "紐付け数: #{FacilityMatch.count}"
end
