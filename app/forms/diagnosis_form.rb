class DiagnosisForm
  include ActiveModel::Model

  attr_accessor :answers

  validate :all_questions_answered

  def initialize(params)
    Rails.logger.debug "DiagnosisForm 初期化: #{params.inspect}"
    @answers = extract_answers(params)
    Rails.logger.debug "抽出された回答数: #{@answers.size}"
  end

  def question_answers
    @answers
  end

  private

  def extract_answers(params)
    # ActionController::Parameters の場合は to_h で変換
    hash = params.is_a?(ActionController::Parameters) ? params.to_h : params

    # question_ で始まるキーのみを抽出
    filtered = hash.select { |key, _| key.to_s.start_with?("question_") }

    Rails.logger.debug "フィルタ後のデータ: #{filtered.inspect}"

    filtered
  end

  def all_questions_answered
    total_questions = DiagnosisQuestion.count
    answered_count = @answers.size

    Rails.logger.debug "=== バリデーションチェック ==="
    Rails.logger.debug "必要な質問数: #{total_questions}"
    Rails.logger.debug "回答された質問数: #{answered_count}"

    return if answered_count == total_questions

    Rails.logger.debug "バリデーションエラー: 必要#{total_questions}件、実際#{answered_count}件"
    errors.add(:base, "すべての質問に回答してください")
  end
end
