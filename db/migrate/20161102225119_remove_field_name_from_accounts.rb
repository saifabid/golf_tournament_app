class RemoveFieldNameFromAccounts < ActiveRecord::Migration[5.0]
  def change
    remove_column :accounts, :avatar_file_size, :int
    remove_column :accounts, :avatar_file_name, :text
    remove_column :accounts, :avatar_updated_at, :date
    remove_column :accounts, :avatar_content_type, :text
  end
end
