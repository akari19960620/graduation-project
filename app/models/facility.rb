class Facility < ApplicationRecord
  has_many :facility_matches, dependent: :destroy
  has_many :diagnosis_results, through: :facility_matches
end
