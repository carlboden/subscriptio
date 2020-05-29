class Software < ApplicationRecord
    include PgSearch::Model
	multisearchable against: [:name, :category], using: { tsearch: { prefix: true } }
	pg_search_scope :whose_name_starts_with,
                  against: [:name, :category],
                  using: {
                    tsearch: { prefix: true }
                  }

	has_many :software_plans
	validates :name, presence: :true, uniqueness: :true
	validates :category, presence: :true
end
