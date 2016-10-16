class AddTotalPlayerTicketsToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :total_player_tickets, :integer
  end
end
