class UpdateCompanySizeToCompanies < ActiveRecord::Migration[6.0]
  def change
    change_column :companies, :company_size, :string
  end
end
