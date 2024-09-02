class User < ApplicationRecord
  has_many :prices
  has_many :favorites, dependent: :destroy
  has_many :evaluations
  has_many :stores, through: :evaluations, primary_key: 'google_place_id', foreign_key: 'google_place_id'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable

  validates :email, uniqueness: true
  validates :name, uniqueness: true, presence: true

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
      user.name = "ゲスト"
    end
  end

  def evaluated?(store)
    evaluations.exists?(google_place_id: store.google_place_id)
  end
end
