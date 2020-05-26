class SoftwarePlan < ApplicationRecord
  belongs_to :software
  validates :name, presence: :true
  validates :official_price, presence: :true
end
