class CreateCourseAssignments < ActiveRecord::Migration
  def change
    create_table :course_assignments do |t|
      t.integer :course_id, null: false
      t.integer :assignment_id, null: false

      t.timestamps
    end
    
    add_index :course_assignments, :course_id
    add_index :course_assignments, :assignment_id
    add_index :course_assignments, [:course_id, :assignment_id], unique: true
  end
end
