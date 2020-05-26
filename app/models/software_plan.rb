class SoftwarePlan < ApplicationRecord
  belongs_to: :software, dependant: :destroy
  validates :name, presence: :true
  validates :official_price, presence: :true
end
