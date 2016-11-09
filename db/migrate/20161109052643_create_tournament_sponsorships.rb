class CreateTournamentSponsorships < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_sponsorships do |t|
      t.integer :sponsor_type
      t.text :description
      t.decimal :ticket_price
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
