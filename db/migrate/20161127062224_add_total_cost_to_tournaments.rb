class AddTotalCostToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :total_cost, :decimal, :precision => 16, :scale => 2
  end
end
