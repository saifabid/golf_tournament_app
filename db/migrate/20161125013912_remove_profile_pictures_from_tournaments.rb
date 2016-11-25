class RemoveProfilePicturesFromTournaments < ActiveRecord::Migration[5.0]
  def change
  	remove_column :tournaments, :profile_pictures, :text
  end
end
