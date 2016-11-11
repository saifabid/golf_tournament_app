class AddIndividualTourneyGroupNums < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :tournament_group_num, :integer, after: :tournament_id
  end
end
