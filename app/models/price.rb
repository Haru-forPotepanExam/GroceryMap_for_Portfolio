class Price < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :store, primary_key: 'google_place_id', foreign_key: 'google_place_id'

  attr_accessor :store_name

  validates :price_value, presence: true, numericality: { only_integer: true }
  validate :quantity_or_weight
  validate :weight_validity
  validate :quantity_validity
  validates :memo, length: { maximum: 150 }

  def prices_per_gram
    if weight.present?
      gram_price = price_value / weight * 100
      gram_price.round
    end
  end

  def prices_per_quantity
    if quantity.present?
      quantity_price = price_value / quantity
      quantity_price.round
    end
  end

  def self.min_price
    order(:price_value).first
  end

  def quantity_or_weight
    if quantity.blank? && weight.blank?
      errors.add(:base, "個数、またはグラム数のどちらかを入力してください。")
    end
  end

  def weight_validity
    if weight.present?
      if !weight.is_a?(Integer) || weight <= 0
        errors.add(:weight, "は100グラム以上、かつグラム単位で入力してください。")
      end
    end
  end

  def quantity_validity
    if quantity.present?
      if !quantity.is_a?(Integer) || quantity <= 0
        errors.add(:quantity, "は1以上の数値を入力してください。")
      end
    end
  end

  def self.ransackable_attributes(options = {})
    %w(memo price_value)
  end

  def self.ransackable_associations(options = {})
    %w(product)
  end

  def lowest_price
    place_id = params[:place_id]
    prices = Price.where(google_place_id: place_id)
    lowest_price = prices.minimum(:price)

    render json: { lowest_price: lowest_price }
  end
end
