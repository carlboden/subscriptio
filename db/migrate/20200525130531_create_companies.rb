class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :address
      t.string :country
      t.bigint :company_size
      t.float :turnover
      t.references :subscriptio_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
