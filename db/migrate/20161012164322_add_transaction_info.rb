class AddTransactionInfo < ActiveRecord::Migration[5.0]
  def change
  	add_column :signups, :transaction_number, :integer, limit: 8, after: :sponsor_tickets
  	add_column :signups, :ticket_numbers, :text, after: :transaction_number
  end
end
