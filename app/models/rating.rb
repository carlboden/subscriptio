class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :software_plan
end
