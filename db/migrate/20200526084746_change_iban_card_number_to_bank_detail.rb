class ChangeIbanCardNumberToBankDetail < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_details, :card, :string
    remove_column :bank_details, :iban
  end
end
