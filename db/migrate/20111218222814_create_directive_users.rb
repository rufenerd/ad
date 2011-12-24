class CreateDirectiveUsers < ActiveRecord::Migration
  def self.up
    create_table :directive_users do |t|
      t.timestamps
      t.string :kind
      t.integer :user_id
      t.integer :directive_id
    end
  end
  
  def self.down
    drop_table :directive_users
  end
end
