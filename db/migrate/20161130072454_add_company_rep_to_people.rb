class AddCompanyRepToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :company_rep, :boolean
  end
end
