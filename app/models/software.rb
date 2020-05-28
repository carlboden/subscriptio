class Software < ApplicationRecord
	include PgSearch::Model
    multisearchable against: [:name, :category]

	has_many :software_plans
	validates :name, presence: :true, uniqueness: :true
	validates :category, presence: :true
end
