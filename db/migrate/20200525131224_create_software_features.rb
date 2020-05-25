class CreateSoftwareFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :software_features do |t|
      t.references :software_plan, null: false, foreign_key: true
      t.references :feature, null: false, foreign_key: true

      t.timestamps
    end
  end
end
