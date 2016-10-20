class AddMobileNum < ActiveRecord::Migration[5.0]
  def change
  	add_column :accounts, :mobile_phone, :string
  	add_column :accounts, :is_home, :boolean
  	remove_column :accounts, :is_billing, :boolean
  end
end
