class AddDinnerPrice < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :dinner_price, :integer, after: :spectator_price
  end
end
