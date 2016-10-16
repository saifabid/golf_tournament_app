class AddTicketsRemaining < ActiveRecord::Migration[5.0]
  def change
  	add_column :people, :ticket_description, :integer, after: :ticket_number
  	add_column :tournaments, :tickets_left, :integer, after: :is_private
  end
end
