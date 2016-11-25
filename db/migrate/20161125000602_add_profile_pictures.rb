class AddProfilePictures < ActiveRecord::Migration[5.0]
  def change
  	create_table :tournament_profile_pictures do |t|
  	 	t.references :tournament, foreign_key: true
      t.string :image
      
      t.timestamps
    end
  end
end
