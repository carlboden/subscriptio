class Company < ApplicationRecord
  belongs_to :subscriptio_plan
  has_one :bank_detail, dependent: :destroy
  validates :name, uniqueness: true
end
