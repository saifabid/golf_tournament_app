class Tournaments < ActiveRecord::Migration[5.0]
  def change
	add_column :people, :score, :integer
  end
end
