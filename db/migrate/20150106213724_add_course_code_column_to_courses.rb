class AddCourseCodeColumnToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :course_code, :string, null: false
    add_index :courses, :course_code, unique: true
  end
end
