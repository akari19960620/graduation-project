class DiagnosisQuestion < ApplicationRecord
  has_many :diagnosis_answers, dependent: :destroy
  has_many :diagnosis_options, dependent: :destroy

  validates :question_text, presence: true
  validates :question_type, presence: true
  # numericality: { only_integer: true, greater_than_or_equal_to: 0 }このバリデーションは、０以上の整数のみ許可
  validates :display_order, presence: true, numericality: { only_integer: true, greater_than_or_equel_to: 0 }

  # スコープ：表示順序でソート
  scope :ordered, -> { order(display_order: :asc) }
end
