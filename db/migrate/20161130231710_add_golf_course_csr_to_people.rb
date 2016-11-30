class AddGolfCourseCsrToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :golf_course_csr, :boolean
  end
end
