class UpdateCvvTypeToBankDetails < ActiveRecord::Migration[6.0]
  def change
    change_column :bank_details, :cvv, :string
  end
end
