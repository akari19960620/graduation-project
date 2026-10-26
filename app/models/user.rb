class User < ApplicationRecord
  authenticates_with_sorcery!

  attr_accessor :password_confirmation

  has_many :diagnoses, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 8, maximum: 16 },
            format: {
              with: /\A(?=.*[a-z])(?=.*[0-9])[a-z0-9]+\z/i,
              message: "は半角英数字をそれぞれ1文字以上含めて設定してください"
            },
            confirmation: true,
            if: -> { new_record? || password.present? }
end
