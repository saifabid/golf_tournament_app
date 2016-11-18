class AddDistanceToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :distance, :Decimal
  end
end
