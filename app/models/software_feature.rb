class SoftwareFeature < ApplicationRecord
  belongs_to :software_plan
  belongs_to :feature, dependent: :destroy
end
