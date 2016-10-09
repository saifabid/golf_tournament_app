class CreateSignups < ActiveRecord::Migration[5.0]
  def change
    create_table :signups do |t|
      t.integer :user_id
      t.integer :tournament_id
      t.integer :player_tickets
      t.integer :sponsor_tickets

      t.timestamps
    end
  end
end
