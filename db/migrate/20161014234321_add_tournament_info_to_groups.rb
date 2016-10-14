class AddTournamentInfoToGroups < ActiveRecord::Migration[5.0]
  def change
  	add_column :groups, :tournament_id, :integer, after: :id

  	add_column :people, :fname, :text, after: :guest_of
  	add_column :people, :lname, :text, after: :fname
  end
end
