class AddGroupInformation < ActiveRecord::Migration[5.0]
  def change
  	add_column :people, :group_number, :integer, after: :guest_of

  	create_table :groups do |t|
      t.integer :current_members
      t.integer :member_one
      t.integer :member_two
      t.integer :member_three
      t.integer :member_four
      t.timestamps
    end
  end
end
