class AddNumFoursomesToTournaments < ActiveRecord::Migration[5.0]
  def change
  	add_column :tournaments, :num_foursomes, :integer
  end
end
