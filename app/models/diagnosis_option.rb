class DiagnosisOption < ApplicationRecord
  belongs_to :diagnosis_question
  has_many :diagnosis_answers, dependent: :destroy

  validates :option_text, presence: true
  validates :weight_value, presence: true, numericality: { only_integer: true }
  validates :display_order, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(display_order: :asc) }
end
