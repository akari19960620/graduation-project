# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 既存のデータを削除する（開発環境のみ）
if Rails.env.development?
  Facility.destroy_all
end

# 施設データの投入
Facility.create!(
  name: "青葉ヒルズ",
  facility_type: "特別養護老人ホーム",
  address: "神奈川県横浜市青葉区鴨志田町1260",
  phone: "0037-630-21227",
  monthly_fee_min: "3.87万円",
  monthly_fee_max: "16.26万円",
  capacity: "140名",
  room_type: "ユニット型個室",
  care_level: "要介護1~5（要介護1、2は特例入所要件該当者のみ）",
  services: "医療サービス、介護サービス、個別リハビリ等全般（詳細はホームページを参照ください）",
  features: "自然に恵まれた好環境、都心から近い好立地で居住エリアは10人単位のユニット。クラブ活動や季節ごとの行事の他、機能訓練や音楽・美術プログラムなど青葉ヒルズならではのアクティビティが日常生活の一部として定着している"
)

Facility.create!(
  name: "中銀ライフケア横浜",
  facility_type: "シニア向け分譲マンション",
  address: "神奈川県横浜市都筑区新栄町14-1中銀ライフケア横浜（港北）",
  phone: "0037-630-77625",
  monthly_fee_min: "7.21万円",
  monthly_fee_max: "8.19万円",
  capacity: "443室",
  room_type: "個室",
  care_level: "入居条件：自立（介護認定を受けていないこと）",
  services: "24時間看護師常駐で健康管理のお手伝いや、施設責任者やスタッフが生活全般のご相談に対応。",
  features: "所有権分譲方式の売却もでき、相続財産にもなる個人資産。アクセスの良い立地で栄養バランスの整った温かい食事、喫茶・大浴場・麻雀室など充実の共用施設もある。（入居時費用あり）"
)

Facility.create!(
  name: "すいとぴー本牧三渓園",
  facility_type: "介護付き有料老人ホーム",
  address: "神奈川県横浜市中区本牧原1-11",
  phone: "0037-630-53267",
  monthly_fee_min: "25.06万円",
  monthly_fee_max: "39.42万円",
  capacity: "-",
  room_type: "個室",
  care_level: "要介護1～5",
  services: "医療サービス、介護サービス、個別リハビリ等全般（詳細はホームページを参照ください）",
  features: "豊かな緑に囲まれた環境と眺望を備えた居住空間で上質な暮らしを実現。また、国の基準を上回る2対1の手厚い介護体制と建物内にクリニックがあり看護師が24時間常駐している"
)

Facility.create!(
  name: "横浜エデンの園",
  facility_type: "介護付き有料老人ホーム",
  address: "神奈川県横浜市保土ケ谷区岩井町207",
  phone: "0037-630-93158",
  monthly_fee_min: "20.42万円",
  monthly_fee_max: "57.51万円",
  capacity: "-",
  room_type: "個室",
  care_level: "要支援1～2、要介護1～5",
  services: "介護サービス、個別リハビリ等（協力医療機関病院隣接）",
  features: "当事業団が設置・運営する協力医療機関・聖隷横浜病院に隣接しており、医住近接の環境を実現。看護師24時間常駐。ご入居者の嚥下・咀嚼レベルに合わせた食事形態や治療食にも対応（入居時費用あり）"
)

Facility.create!(
  name: "ALSOKケアホーム横浜港南台",
  facility_type: "介護付き有料老人ホーム",
  address: "神奈川県横浜市港南区日野中央三丁目15番2号",
  phone: "0037-630-83746",
  monthly_fee_min: "21.5万円",
  monthly_fee_max: "-",
  capacity: "-",
  room_type: "個室",
  care_level: "要介護1～5",
  services: "要問合せ",
  features: "2026年2月新築オープン。館内Wi-Fi完備。プライバシーに配慮した見守りセンサーや介護記録システムを導入し、安全安心を最優先に、快適な住環境を提供している（入居時費用あり）"
)

Facility.create!(
  name: "ALSOKグループホーム横浜上飯田Ⅱ",
  facility_type: "グループホーム",
  address: "神奈川県横浜市泉区上飯田町3795-9",
  phone: "0037-630-92331",
  monthly_fee_min: "16.31万円",
  monthly_fee_max: "-",
  capacity: "18名",
  room_type: "個室",
  care_level: "要支援2、要介護1～5（その他条件あり）",
  services: "介護サービス、訪問診療、訪問歯科診療、訪問リハビリ等",
  features: "ＡＬＳＯＫグループならではのコンテンツや独自の運動プログラムを積極的に導入し健康増進につとめています"
)

Facility.create!(
  name: "プレゼンス野庭",
  facility_type: "グループホーム",
  address: "神奈川県横浜市港南区野庭町675-20",
  phone: "0037-630-01444",
  monthly_fee_min: "15.8万円",
  monthly_fee_max: "-",
  capacity: "-",
  room_type: "個室",
  care_level: "要介護1～5（認知症診断必須）",
  services: "介護サービス（自立支援）",
  features: "地域との関わりや屋外・外出イベント等の季節に合ったイベントを開催（入居時費用あり）"
)

Facility.create!(
  name: "フォーシーズンズヴィラそよかぜ",
  facility_type: "ケアハウス",
  address: "神奈川県横浜市緑区三保町880",
  phone: "0037-630-65419",
  monthly_fee_min: "17.5万円",
  monthly_fee_max: "22.97万円",
  capacity: "100名",
  room_type: "個室",
  care_level: "要介護1～5",
  services: "介護サービス、医療サービス（日中のみ看護師）、往診体制あり、保険外サービスあり",
  features: "完全個室ユニット型、２：１の手厚い介護人員配置、季節感を感じられる毎月のレクリエーションの実施（入居時費用あり）"
)

Facility.create!(
  name: "ケアハウスゆうあい",
  facility_type: "ケアハウス",
  address: "神奈川県横浜市戸塚区川上町84-1",
  phone: "",
  monthly_fee_min: "10.47万円",
  monthly_fee_max: "15.39万円",
  capacity: "139名",
  room_type: "個室",
  care_level: "自立、要支援1～2、要介護1～5",
  services: "介護サービス、医療サービス",
  features: "一人一人の状態に合った形で包括的な介護サービスの提供を受けることが出来、季節ごとの行事や同施設内の学園祭にも自由に参加できる（入居時費用あり）"
)

Facility.create!(
  name: "やまゆりホーム",
  facility_type: "特別養護老人ホーム",
  address: "神奈川県横浜市鶴見区獅子ケ谷2-15-18",
  phone: "045-583-1833",
  monthly_fee_min: "要確認",
  monthly_fee_max: "-",
  capacity: "80名",
  room_type: "1人部屋、2人部屋、4人部屋",
  care_level: "要介護3～5",
  services: "介護サービス、医療サービス",
  features: "ご利用者の立場に立ち、自立した生活を営めるよう支援することを心がけ、サービス提供に努めている"
)
