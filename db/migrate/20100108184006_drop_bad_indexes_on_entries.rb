class DropBadIndexesOnEntries < ActiveRecord::Migration
  def self.up
    add_index :entries, :user_id
    add_index :entries, :is_private
    add_index :entries, :is_voteable
    add_index :entries, :created_at
  end

  def self.down
  end
end
