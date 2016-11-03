class AddLinkToAccounts < ActiveRecord::Migration[5.0]
  def change
  	add_column :accounts, :profile_pic, :text
  end
end
