class AddTotalAudienceTicketsToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :total_audience_tickets, :integer
  end
end
