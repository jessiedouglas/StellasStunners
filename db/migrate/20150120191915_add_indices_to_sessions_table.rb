class AddIndicesToSessionsTable < ActiveRecord::Migration
  def change
    add_index :sessions, :user_id
    add_index :sessions, :token, unique: true
  end
end
