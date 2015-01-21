class RemoveTokenFromAssignments < ActiveRecord::Migration
  def up
    remove_column :assignments, :token
  end
  
  def down
    add_column :assignments, :token, :string, null: false
  end
end
