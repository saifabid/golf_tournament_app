class CorrectSpectatorColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :tournaments, :spctator_tickets_left, :spectator_tickets_left
  end
end
