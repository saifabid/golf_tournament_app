class AddStartEndToGroups < ActiveRecord::Migration[5.0]
  def change
  	add_column :groups, :start, :time
  	add_column :groups, :end, :time, after: :start
  end
end