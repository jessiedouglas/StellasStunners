class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :teacher_id, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
    
    add_index :courses, :teacher_id
    add_index :courses, [:teacher_id, :title], unique: true
  end
end
