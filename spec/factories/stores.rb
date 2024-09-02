FactoryBot.define do
  factory :store do
    sequence(:google_place_id) { |n| "google_place_id#{n}" }
    sequence(:name) { |n| "store#{n}" }
    latitude { 35.6910 }
    longitude { 139.6930 }
  end
end
