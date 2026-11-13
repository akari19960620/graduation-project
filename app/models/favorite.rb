class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :facility

  # user_id, facility_idの組み合わせが一意である
  validates :user_id, uniqueness: { scope: :facility_id }
end
