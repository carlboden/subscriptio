class Feature < ApplicationRecord
    include PgSearch::Model
    multisearchable against: :name

    pg_search_scope :whose_name_starts_with,
                  against: :name,
                  using: {
                    tsearch: { prefix: true }
                  }
    
	has_many :software_features
	validates :name, presence: :true
end
