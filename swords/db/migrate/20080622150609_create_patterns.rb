class CreatePatterns < ActiveRecord::Migration
  def self.up
    create_table :patterns do |t|
      t.integer :columns
      t.integer :rows
      t.text :map

      t.timestamps
    end
  end

  def self.down
    drop_table :patterns
  end
end
