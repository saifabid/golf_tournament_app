class AddViewPublicOption < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :org_view_public, :boolean
  end
end
