class FacilityMatch < ApplicationRecord
  belongs_to :diagnosis_result
  belongs_to :facility
end
