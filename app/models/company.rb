class Company < ApplicationRecord
  belongs_to :subscriptio_plan
  has_one :bank_detail, dependent: :destroy
  validates :name, uniqueness: true

  SIZES = ['Less than 5', 'Between 5 and 10', 'Between 10 and 49', 'Between 50 and 499', '500 and more']
  TURNOVERS = ['Less than €100k', 'Between €100k and €500k', 'Between €500k and €1 Million', 'Between €1 Million and €5 Million', 'Between €5 Million and €10 Million', 'Between €10 Million and €50 Million', 'More than €50 Million' ]
end
