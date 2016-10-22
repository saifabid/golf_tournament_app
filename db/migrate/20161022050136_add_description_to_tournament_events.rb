class AddDescriptionToTournamentEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :tournament_events, :description, :string
  end
end
