class Feature < ApplicationRecord
    include PgSearch::Model
    multisearchable against: [:name]

	has_many :software_features
	validates :name, presence: :true
end
