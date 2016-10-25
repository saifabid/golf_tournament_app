class CreateTicketTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_transactions do |t|
      t.bigint :transaction_number
      t.references :user, foreign_key: true
      t.decimal :amount_paid

      t.timestamps
    end

  end

end
