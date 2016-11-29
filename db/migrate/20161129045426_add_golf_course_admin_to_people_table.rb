class AddGolfCourseAdminToPeopleTable < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :is_golf_course_admin, :boolean
  end
end
