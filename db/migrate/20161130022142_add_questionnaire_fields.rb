class AddQuestionnaireFields < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :player_questionnaire, :boolean
    add_column :tournaments, :questionnaire_name, :string
    add_column :people, :survey_admin, :integer
  end
end
