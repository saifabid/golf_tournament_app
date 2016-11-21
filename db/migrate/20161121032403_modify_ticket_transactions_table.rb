class ModifyTicketTransactionsTable < ActiveRecord::Migration[5.0]
  def change
    change_column :ticket_transactions, :amount_paid, :decimal, :precision => 16, :scale => 2
    add_column :ticket_transactions, :currency, :string, :null=>false, :default=>'cad'
  end
end
