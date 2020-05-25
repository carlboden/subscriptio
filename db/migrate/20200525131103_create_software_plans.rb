class CreateSoftwarePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :software_plans do |t|
      t.float :official_price
      t.string :name
      t.references :software, null: false, foreign_key: true

      t.timestamps
    end
  end
end
