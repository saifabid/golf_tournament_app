class AddPrivateEventPassword < ActiveRecord::Migration[5.0]
  def change
  	add_column :tournaments, :private_event_password, :string, after: :is_private
  end
end
