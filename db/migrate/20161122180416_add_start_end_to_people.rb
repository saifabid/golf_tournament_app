class AddStartEndToPeople < ActiveRecord::Migration[5.0]
  def change
  	add_column :people, :start, :time, after: :group_number
  	add_column :people, :end, :time, after: :start
  end
end
