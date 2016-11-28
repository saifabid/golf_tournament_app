class TicketTransactionSurcharge < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_transactions, :card_surcharge, :decimal, :precision => 16, :scale => 2, after: :amount_paid
  end
end
