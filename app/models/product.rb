class Product < ApplicationRecord
  belongs_to :category

  has_many :prices

  validates :name, uniqueness: true, presence: true

  def self.ransackable_attributes(options = {})
    %w(name)
  end

  def self.ransackable_associations(options = {})
    ["prices"]
  end
end
