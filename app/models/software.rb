class Software < ApplicationRecord
	has_many :software_plan
	validates :name, presence: :true, uniqueness: :true
	validates :category, presence: :true
end
