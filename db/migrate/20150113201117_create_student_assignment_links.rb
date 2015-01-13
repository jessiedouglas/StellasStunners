class CreateStudentAssignmentLinks < ActiveRecord::Migration
  def change
    create_table :student_assignment_links do |t|
      t.integer :assignment_id, null: false
      t.integer :student_id, null: false

      t.timestamps
    end
    
    add_index :student_assignment_links, :assignment_id
    add_index :student_assignment_links, :student_id
  end
end
