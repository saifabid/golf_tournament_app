class AddStartDateToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :start_date, :datetime
  end
end
