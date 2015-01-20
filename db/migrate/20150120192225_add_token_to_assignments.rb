class AddTokenToAssignments < ActiveRecord::Migration
  def change
    Assignment.destroy_all
    add_column :assignments, :token, :string, null: false
    add_index :assignments, :token, unique: true
  end
end
