class DiagnosisForm
  include ActiveModel::Model

  attr_accessor :answers

  validate :all_questions_answered

  def initialize(params)
    @answers = extract_answers(params)
  end

  def question_answers
    @answers
  end

  private

  def extract_answers(params)
    params.select { |key, _| key.to_s.start_with?('question_') }.to_h
  end

  def all_questions_answered
    total_questions = DiagnosisQuestion.count
    answered_count = @answers.size

    return if answered_count == total_questions

    errors.add(:base, 'すべての質問に回答してください')
  end
end