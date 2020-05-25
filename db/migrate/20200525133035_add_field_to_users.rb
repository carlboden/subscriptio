class AddFieldToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :function, :string
    add_column :users, :company_admin, :boolean
    add_column :users, :admin, :boolean
    add_reference :users, :company, foreign_key: true
  end
end
