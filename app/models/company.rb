class Company < ApplicationRecord
  belongs_to :subscriptio_plan
  has_many :users, dependent: :destroy
  has_one :bank_detail, dependent: :destroy
end
