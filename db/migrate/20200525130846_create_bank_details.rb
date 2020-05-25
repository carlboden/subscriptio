class CreateBankDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :bank_details do |t|
      t.string :iban
      t.date :expiration_date
      t.integer :cvv
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
