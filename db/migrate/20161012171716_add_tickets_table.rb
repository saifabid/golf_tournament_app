class AddTicketsTable < ActiveRecord::Migration[5.0]
  def change
  	remove_column :signups, :ticket_numbers, :text

  	create_table :tickets do |t|
      t.integer :transaction_number, limit: 8
      t.integer :user_id
      t.integer :tournament_id
      t.boolean :sponsor_ticket
      t.boolean :player_ticket
      t.timestamps
     end
  end
end
