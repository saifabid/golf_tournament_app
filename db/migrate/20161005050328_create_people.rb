class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.references :user # Will add user_id
      t.references :tournament # Will add tournament_id

      t.boolean :is_organizer
      t.boolean :is_admin
      t.boolean :is_guest
      t.boolean :is_player
      t.boolean :is_sponsor
      t.timestamps
    end
  end
end
