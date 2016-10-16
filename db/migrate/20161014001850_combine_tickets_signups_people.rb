class CombineTicketsSignupsPeople < ActiveRecord::Migration[5.0]
  def change
  	drop_table :tickets
  	drop_table :signups

  	add_column :people, :transaction_number, :integer, limit: 8, after: :is_sponsor 
  	add_column :people, :ticket_number, :integer, limit: 8, after: :transaction_number
  	add_column :people, :guest_of, :integer, after: :ticket_number
  	add_column :people, :checked_in, :boolean, after: :guest_of
  end
end
