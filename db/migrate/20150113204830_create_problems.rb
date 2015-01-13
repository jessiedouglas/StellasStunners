class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.text :solution, null: false
      t.decimal :stella_number
      t.boolean :is_original

      t.timestamps
    end
  end
end
