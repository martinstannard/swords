class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.integer :crossword_id, :null => false
      t.string :answer, :null => false
      t.string :clue, :null => false
      t.integer :col, :null => false
      t.integer :row, :null => false
      t.string :direction, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :words
  end
end
