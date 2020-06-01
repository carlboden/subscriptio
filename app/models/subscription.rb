class Subscription < ApplicationRecord
  include PgSearch::Model

  belongs_to :company
  belongs_to :software_plan
  has_one :software, through: :software_plan
  validates :price, presence: :true

  pg_search_scope :software_search, associated_against: {
    software: :name,
  }, using: { tsearch: { prefix: true } }
end
