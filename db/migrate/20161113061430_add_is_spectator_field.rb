class AddIsSpectatorField < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :is_spectator, :boolean, after: :is_sponsor
  end
end
