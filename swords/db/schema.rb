# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080622151207) do

  create_table "crosswords", :force => true do |t|
    t.integer  "pattern_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patterns", :force => true do |t|
    t.integer  "columns",    :limit => 11
    t.integer  "rows",       :limit => 11
    t.text     "map"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "words", :force => true do |t|
    t.integer  "crossword_id", :limit => 11, :null => false
    t.string   "answer",                     :null => false
    t.string   "clue",                       :null => false
    t.integer  "col",          :limit => 11, :null => false
    t.integer  "row",          :limit => 11, :null => false
    t.string   "direction",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
