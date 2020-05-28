class SoftwarePlan < ApplicationRecord
  belongs_to :software
  has_many :software_features, dependent: :destroy
  has_many :ratings, dependent: :destroy
  validates :name, presence: :true
  validates :official_price, presence: :true
end
