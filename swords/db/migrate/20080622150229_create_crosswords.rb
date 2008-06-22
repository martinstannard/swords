class CreateCrosswords < ActiveRecord::Migration
  def self.up
    create_table :crosswords do |t|
      t.integer :pattern_id

      t.timestamps
    end
  end

  def self.down
    drop_table :crosswords
  end
end
