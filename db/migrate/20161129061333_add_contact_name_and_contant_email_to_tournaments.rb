class AddContactNameAndContantEmailToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :contact_name, :string
    add_column :tournaments, :contact_email, :string
  end
end
