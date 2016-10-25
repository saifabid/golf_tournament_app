class AddTransactionIdToPeople < ActiveRecord::Migration[5.0]
  def change
    add_reference :people, :ticket_transaction, index: true, foreign_key: true
    remove_column :people, :transaction_number
  end
end
