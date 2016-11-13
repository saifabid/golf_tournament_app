class AddingTotalSpectatorTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :spctator_tickets_left, :integer, after: :tickets_left
  end
end
