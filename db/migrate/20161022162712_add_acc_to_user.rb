class AddAccToUser < ActiveRecord::Migration[5.0]
  def change
  	add_reference :users, :account, index: true, foreign_key: true
  end
end
