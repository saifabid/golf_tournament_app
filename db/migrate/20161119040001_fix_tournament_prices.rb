class FixTournamentPrices < ActiveRecord::Migration[5.0]
  def change
    change_column :tournaments, :silver_sponsor_price, :decimal, :precision => 16, :scale => 2
    change_column :tournaments, :gold_sponsor_price, :decimal, :precision => 16, :scale => 2
    change_column :tournaments, :bronze_sponsor_price, :decimal, :precision => 16, :scale => 2
    change_column :tournaments, :player_price, :decimal, :precision => 16, :scale => 2
    change_column :tournaments, :dinner_price, :decimal, :precision => 16, :scale => 2
    change_column :tournaments, :spectator_price, :decimal, :precision => 16, :scale => 2
    change_column :tournaments, :foursome_price, :decimal, :precision => 16, :scale => 2
  end
end
