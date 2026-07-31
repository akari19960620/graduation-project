class DiagnosesController < ApplicationController
  
  def index
    @diagnoses = DiagnosisQuestion.includes(:diagnosis_options).order(:display_order)
  end

  def result
    # 回答を保存
    save_responses_to_session
    # スコアを計算
    @total_score = calculate_total_score
    # 診断結果を取得
    @diagnosis_result = DiagnosisResult.find_by_score(@total_score)
    # ビューで使用するために回答データを整形
    @user_responses = format_user_responses
  end

  private
  
  def save_responses_to_session
    # 質問と選択肢のペアをセッションに保存
    responses = {}

    params.each do |key, value|
      next unless key.start_with?('question_')

      question_id = key.split('_').last.to_i
      option_id = value.to_i

      responses[question_id] = option_id
    end

    session[:diagnosis_responses] = responses
  end

  def calculate_total_score
    # paramsから選択肢IDを取得してスコアを計算
    option_ids = params.values.select { |v| v.to_s =~ /^\d+$/ }.map(&:to_i)
    DiagnosisOption.where(id: option_ids).sum(:score)
  end
  
  def format_user_responses
    # セッションから回答を取得
    responses = session[:diagnosis_responses] || {}

    # 質問と選択肢の情報を取得
    responses.map do |question_id, option_id|
      question = DiagnosisQuestion.find(question_id)
      option = DiagnosisOption.find(option_id)

      {
        question: question,
        option: option
      }
    end
  end
end
