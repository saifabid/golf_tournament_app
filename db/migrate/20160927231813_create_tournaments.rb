class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :logo
      t.string :language
      t.string :currency
      t.string :profile_pictures
      t.string :details
      t.string :venue_name
      t.string :venue_logo
      t.string :venue_address
      t.string :venue_website
      t.string :venue_contact_details
      t.boolean :is_private

      # ticket, registration details in it's own table
      # event schedule in it's own table
      # tournament features in their own table
      # sponsorship details in their own table
      # contact goes in the tournament_players table

      t.timestamps
    end
  end
end
