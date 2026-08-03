class Diagnosis < ApplicationRecord
  has_many :diagnosis_answers, dependent: :destroy
  belongs_to :diagnosis_result, optional: true

  validates :session_id, presence: true, uniqueness: true

  # enum定義
  enum :status, { in_progress: 0, completed: 1 }, default: :in_progress
end
