class Feature < ApplicationRecord
	has_many :software_features
	validates :name, presence: :true
end
