class CreateTournamentFeatures < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_features do |t|
      t.references :tournament, foreign_key: true
      t.string :name
      t.string :description
      
      t.timestamps
    end
  end
end
