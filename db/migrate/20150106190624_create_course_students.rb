class CreateCourseStudents < ActiveRecord::Migration
  def change
    create_table :course_students do |t|
      t.integer :course_id, null: false
      t.integer :student_id, null: false

      t.timestamps
    end
    
    add_index :course_students, :course_id
    add_index :course_students, :student_id
    add_index :course_students, [:course_id, :student_id], unique: true
  end
end
