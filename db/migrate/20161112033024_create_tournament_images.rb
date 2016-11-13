class CreateTournamentImages < ActiveRecord::Migration[5.0]
  def change
    create_table :tournament_images do |t|
      t.references :tournament, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
