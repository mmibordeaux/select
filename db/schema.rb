# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_15_191109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "baccalaureats", force: :cascade do |t|
    t.string "title"
    t.bigint "parent_id"
    t.float "quota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_baccalaureats_on_parent_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "number"
    t.string "first_name"
    t.string "last_name"
    t.bigint "baccalaureat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["baccalaureat_id"], name: "index_candidates_on_baccalaureat_id"
  end

  add_foreign_key "baccalaureats", "baccalaureats", column: "parent_id"
  add_foreign_key "candidates", "baccalaureats"
end
