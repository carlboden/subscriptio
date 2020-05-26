class BankDetail < ApplicationRecord
  belongs_to :company
  belongs_to :user
  validates :card, presence: true
  validates :expiration_date, presence: true
  validates :cvv, presence: true, length: { is: 3 }
end
