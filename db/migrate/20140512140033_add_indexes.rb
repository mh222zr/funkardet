class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :users, :username
  end

  def self.down
    remove_index :users, :username
  end
end
