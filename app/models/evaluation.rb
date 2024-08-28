class Evaluation < ApplicationRecord
  belongs_to :user
  belongs_to :store, primary_key: 'google_place_id', foreign_key: 'google_place_id'

  PRICE_VALUE = ["安価", "やや安価", "平均", "やや高価", "高価"]

  validates :price_range, presence: true, inclusion: { in: PRICE_VALUE }

  scope :lowest, -> { where(price_range: "安価") }
  scope :lower, -> { where(price_range: "やや安価") }
  scope :middle, -> { where(price_range: "平均") }
  scope :haigher, -> { where(price_range: "やや高価") }
  scope :haighest, -> { where(price_range: "高価") }

  def self.price_value_to_score(price_range)
    case price_range
    when "安価" then 1
    when "やや安価" then 2
    when "平均" then 3
    when "やや高価" then 4
    when "高価" then 5
    else 0
    end
  end

  def self.average_evaluation(store_google_place_id)
    evaluations = where(google_place_id: store_google_place_id)
    return 0 if evaluations.empty?

    evaluations.average(:price_score).round
  end

  def self.average_evaluation_label(store_google_place_id)
    average_score = average_evaluation(store_google_place_id)

    if average_score.between?(1, PRICE_VALUE.length)
      PRICE_VALUE[average_score - 1]
    else
      "評価なし"
    end
  end
end
