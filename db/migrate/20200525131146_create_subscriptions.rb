class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.date :start_date
      t.date :end_date
      t.float :price
      t.references :company, null: false, foreign_key: true
      t.references :software_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
