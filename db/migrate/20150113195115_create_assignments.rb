class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :teacher_id, null: false
      t.string :title, null: false
      t.text :description
      t.date :due_date

      t.timestamps
    end
    
    add_index :assignments, :teacher_id
  end
end
