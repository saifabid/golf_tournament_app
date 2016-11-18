class AddDinnerTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :dinner_tickets_left, :integer, after: :spectator_tickets_left
    add_column :tournaments, :total_dinner_tickets, :integer, after: :total_audience_tickets
    add_column :people, :is_dinner, :boolean, after: :is_spectator
  end
end
