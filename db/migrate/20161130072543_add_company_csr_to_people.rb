class AddCompanyCsrToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :company_csr, :boolean
  end
end
