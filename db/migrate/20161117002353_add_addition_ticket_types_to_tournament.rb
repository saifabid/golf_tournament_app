class AddAdditionTicketTypesToTournament < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :foursome_price, :decimal
    add_column :tournaments, :spectator_price, :decimal
  end
end
