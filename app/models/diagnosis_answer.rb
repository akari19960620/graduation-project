class DiagnosisAnswer < ApplicationRecord
  belongs_to :diagnosis
  belongs_to :diagnosis_question
  belongs_to :diagnosis_option

  # 1つの診断内で同じ質問に複数回答できないようにする
  validates :diagnosis_question_id, presence: true, uniqueness: { scope: :diagnosis_id }
  validates :diagnosis_option_id, presence: true
end
