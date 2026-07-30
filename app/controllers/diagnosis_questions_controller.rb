class DiagnosisQuestionsController < ApplicationController
  def index
    @diagnosis_questions = DiagnosisQuestion.all.order(:display_order)
  end

  def result
  end
end
