class CreateTeacherStudentLinks < ActiveRecord::Migration
  def change
    create_table :teacher_student_links do |t|
      t.integer :teacher_id, null: false
      t.integer :student_id, null: false

      t.timestamps
    end
    
    add_index :teacher_student_links, :teacher_id
    add_index :teacher_student_links, :student_id
    add_index :teacher_student_links, [:teacher_id, :student_id], unique: true
  end
end
