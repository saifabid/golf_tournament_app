class AddGuestNumberToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :guest_number, :int
  end
end
