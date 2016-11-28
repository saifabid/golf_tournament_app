class AddOrganizerPaid < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :organizer_paid, :boolean
  end
end
