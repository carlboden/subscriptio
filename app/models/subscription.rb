class Subscription < ApplicationRecord
  belongs_to :company
  belongs_to :software_plan
  validates :price, presence: :true
end
