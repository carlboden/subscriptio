class SoftwarePlan < ApplicationRecord
  belongs_to :software
  has_many :ratings
  validates :name, presence: :true
  validates :official_price, presence: :true
end
