class AddNameToUsers < ActiveRecord::Migration
  def change
    drop_table :users
    create_table :users do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.string :email, null: false
      t.string :session_token, null: false
      t.string :user_type, null: false
      
      t.timestamps
    end
    
    add_index :users, :email, unique: true
    add_index :users, :session_token, unique: true
  end
end
