module DiagnosisTestHelper
  # シードデータと同じ構造の診断質問セットを作成
  def create_complete_diagnosis_questions
    # 質問1
    question1 = create(:diagnosis_question,
      question_text: '駅近で家族が訪問しやすいが料金が高い施設と、郊外で料金が安い施設、どちらを選びますか?',
      weight_category: 'cost_vs_facility',
      display_order: 1
    )
    create(:diagnosis_option, diagnosis_question: question1, option_text: '駅近で家族が訪問しやすい方を重視する', weight_category: 'facility', weight_value: 20, display_order: 1)
    create(:diagnosis_option, diagnosis_question: question1, option_text: '料金が安い方を重視する', weight_category: 'cost', weight_value: 20, display_order: 2)

    # 質問2
    question2 = create(:diagnosis_question,
      question_text: '設備が新しくきれいだが料金が高い施設と、設備は古いが料金が安い施設どちらを選びますか?',
      weight_category: 'facility_vs_cost',
      display_order: 2
    )
    create(:diagnosis_option, diagnosis_question: question2, option_text: '設備が新しい方を重視する', weight_category: 'facility', weight_value: 20, display_order: 1)
    create(:diagnosis_option, diagnosis_question: question2, option_text: '料金が安い方を重視する', weight_category: 'cost', weight_value: 20, display_order: 2)

    # 質問3
    question3 = create(:diagnosis_question,
      question_text: '庭園や散歩スペースが広く自然豊かな施設と、庭園は狭いが医療機関が隣接している施設、どちらを選びますか?',
      weight_category: 'facility_vs_medical',
      display_order: 3
    )
    create(:diagnosis_option, diagnosis_question: question3, option_text: '自然豊かな施設を重視する', weight_category: 'facility', weight_value: 20, display_order: 1)
    create(:diagnosis_option, diagnosis_question: question3, option_text: '医療機関が隣接している施設を重視する', weight_category: 'medical', weight_value: 20, display_order: 2)

    # 質問4
    question4 = create(:diagnosis_question,
      question_text: '看護師が24時間常駐しているが料金が高い施設と、看護師は日中のみだが料金が安い施設、どちらを選びますか?',
      weight_category: 'medical_vs_cost',
      display_order: 4
    )
    create(:diagnosis_option, diagnosis_question: question4, option_text: '看護師が24時間常駐している方を重視する', weight_category: 'medical', weight_value: 20, display_order: 1)
    create(:diagnosis_option, diagnosis_question: question4, option_text: '料金が安い方を重視する', weight_category: 'cost', weight_value: 20, display_order: 2)

    # 質問5
    question5 = create(:diagnosis_question,
      question_text: '娯楽設備が充実している施設と、娯楽設備は少ないが看取りケアや終末期医療に対応している施設、どちらを選びますか?',
      weight_category: 'facility_vs_medical',
      display_order: 5
    )
    create(:diagnosis_option, diagnosis_question: question5, option_text: '娯楽施設が充実している施設を重視する', weight_category: 'facility', weight_value: 20, display_order: 1)
    create(:diagnosis_option, diagnosis_question: question5, option_text: '看取りケアや終末期に対応している施設を重視する', weight_category: 'medical', weight_value: 20, display_order: 2)

    [ question1, question2, question3, question4, question5 ]
  end

  # シードデータと同じ構造の診断結果セットを作成（施設付き）
  def create_complete_diagnosis_results_with_facilities
    # 各タイプの施設を作成
    cost_facilities = create_list(:facility, 5, :cost_focused)
    facility_facilities = create_list(:facility, 5, :facility_focused)
    medical_facilities = create_list(:facility, 5, :medical_focused)

    # コスト重視タイプ
    cost_result = create(:diagnosis_result,
      category: 'cost',
      result_title: 'コスト重視タイプ',
      result_description: 'あなたは費用を重視するタイプです。経済的な負担を抑えることを優先する傾向があります。'
    )
    cost_facilities.each { |facility| create(:facility_match, diagnosis_result: cost_result, facility: facility) }

    # 施設重視タイプ
    facility_result = create(:diagnosis_result,
      category: 'facility',
      result_title: '施設重視タイプ',
      result_description: 'あなたは施設の充実度を重視するタイプです。快適な環境で過ごすことを優先する傾向があります。'
    )
    facility_facilities.each { |facility| create(:facility_match, diagnosis_result: facility_result, facility: facility) }

    # 医療重視タイプ
    medical_result = create(:diagnosis_result,
      category: 'medical',
      result_title: '医療・ケア重視タイプ',
      result_description: 'あなたは医療・ケアの質を重視するタイプです。専門的なサポートを受けることを優先する傾向があります。'
    )
    medical_facilities.each { |facility| create(:facility_match, diagnosis_result: medical_result, facility: facility) }

    [ cost_result, facility_result, medical_result ]
  end
end

RSpec.configure do |config|
  config.include DiagnosisTestHelper, type: :system
end
