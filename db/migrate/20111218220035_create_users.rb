class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.timestamps
      t.string :name
      t.string :username
      t.string :email
      t.string :password_hash, :limit => 64
      t.string :password_salt, :limit => 8
      t.string :role
    end
  end

  def self.down
    drop_table :users
  end
end
