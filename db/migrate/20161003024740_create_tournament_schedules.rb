class CreateTournamentEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_events do |t|
      t.references :tournament, foreign_key: true
      t.string :event_name
      t.time :start_time
      t.time :end_time


      t.timestamps
    end
  end
end

