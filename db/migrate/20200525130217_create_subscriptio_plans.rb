class CreateSubscriptioPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptio_plans do |t|
      t.string :name
      t.float :price
      t.text :description
      t.array :features

      t.timestamps
    end
  end
end
