class AddSurcharge < ActiveRecord::Migration[5.0]
  def change
    rename_column :tournaments, :total_cost, :player_surcharge
    add_column :tournaments, :card_surcharge, :decimal, :precision => 16, :scale => 2
  end
end
