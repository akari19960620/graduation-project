FactoryBot.define do
  factory :diagnosis do
    session_id { SecureRandom.uuid }
    status { :in_progress }
  end
end
