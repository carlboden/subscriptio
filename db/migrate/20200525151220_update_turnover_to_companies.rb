class UpdateTurnoverToCompanies < ActiveRecord::Migration[6.0]
  def change
    change_column :companies, :turnover, :string
  end
end
