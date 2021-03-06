# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

  create_table "bugs", :force => true do |t|
    t.integer  "capture_id"
    t.integer  "line_number"
    t.text     "problem_code"
    t.integer  "original_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "captures", :force => true do |t|
    t.integer  "sampling_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed",   :default => false
  end

  create_table "samplings", :force => true do |t|
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_bug_estimate"
    t.integer  "missing_bug_estimate"
    t.text     "description"
  end

  add_index "samplings", ["uuid"], :name => "index_samplings_on_uuid"

end
