class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|

      t.timestamps
    end
  end
end
