class DiagnosisAnswer < ApplicationRecord
  belongs_to :diagnosis_question
  belongs_to :diagnosis_option

  validates :session_id, presence: true
  validates :diagnosis_question_id, presence: true
  validates :diagnosis_option_id, presence: true
end
