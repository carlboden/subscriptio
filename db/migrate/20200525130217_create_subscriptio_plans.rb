class CreateSubscriptioPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptio_plans do |t|
      t.string :name
      t.float :price
      t.text :description
      t.text :features, array: true, default: []

      t.timestamps
    end
  end
end
