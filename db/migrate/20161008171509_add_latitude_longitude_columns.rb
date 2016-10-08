class AddLatitudeLongitudeColumns < ActiveRecord::Migration[5.0]
  def change
  	add_column :tournaments, :longitude, :float
  	add_column :tournaments, :latitude, :float
  end
end
