FactoryBot.define do
  factory :evaluation do
    association :user
    association :store, primary_key: 'google_place_id', factory: :store
    price_range { "平均" }
    price_score { 3 }
  end
end
