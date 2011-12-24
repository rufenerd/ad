class CreateDirectives < ActiveRecord::Migration
  def self.up
    create_table :directives do |t|
      t.timestamps
      t.string :name
      t.text :materials
      t.text :description
    end
  end

  def self.down
    drop_table :directives
  end
end
