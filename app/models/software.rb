class Software < ApplicationRecord
    include PgSearch::Model
	pg_search_scope :search_by_name_and_category,
	  against: [ :name, :category ],
	  using: {
	    tsearch: { prefix: true } # <-- now `superman batm` will return something!
	  }

	has_many :software_plans
	validates :name, presence: :true, uniqueness: :true
	validates :category, presence: :true
end
