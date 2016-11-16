class AddTicketColumnsToTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :gold_sponsor_price, :decimal, default: 1.00
    add_column :tournaments, :gold_sponsor_desc, :text
    add_column :tournaments, :silver_sponsor_price, :decimal, default:1.00
    add_column :tournaments, :silver_sponsor_desc, :text
    add_column :tournaments, :bronze_sponsor_price, :decimal, default:1.00
    add_column :tournaments, :bronze_sponsor_desc, :text
    add_column :tournaments, :player_price, :decimal
  end
end
