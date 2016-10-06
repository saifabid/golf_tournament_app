class CreateTournamentTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_tickets do |t|
      t.string :ticket_name
      t.text :ticket_desc
      t.decimal :ticket_price
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
