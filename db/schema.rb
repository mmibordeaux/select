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

ActiveRecord::Schema.define(version: 2019_04_12_054401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "baccalaureats", force: :cascade do |t|
    t.string "title"
    t.bigint "parent_id"
    t.float "quota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "evaluation_bonus"
    t.index ["parent_id"], name: "index_baccalaureats_on_parent_id"
  end

  create_table "candidates", force: :cascade do |t|
    t.string "number"
    t.string "first_name"
    t.string "last_name"
    t.bigint "baccalaureat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "dossier_note", default: 0.0
    t.float "evaluation_note", default: 0.0
    t.text "evaluation_comment", default: ""
    t.bigint "evaluated_by_id"
    t.text "level"
    t.bigint "attitude_id"
    t.bigint "intention_id"
    t.bigint "production_id"
    t.bigint "localization_id"
    t.integer "position"
    t.text "parcoursup_entete"
    t.text "parcoursup_scolarite"
    t.text "parcoursup_activites_centres_interet"
    t.text "parcoursup_bac"
    t.text "parcoursup_bulletins"
    t.text "parcoursup_ael"
    t.text "parcoursup_lettre_motivation"
    t.text "parcoursup_groupe"
    t.text "parcoursup_documents"
    t.text "parcoursup_formulaire"
    t.boolean "scholarship", default: false
    t.boolean "production_in_formulaire", default: false
    t.boolean "production_somewhere_else", default: false
    t.boolean "production_analyzed", default: false
    t.bigint "attributed_to_id"
    t.boolean "evaluation_done", default: false
    t.boolean "interview_done", default: false
    t.text "interview_comment"
    t.integer "interview_position"
    t.float "interview_note"
    t.integer "interview_knowledge_id"
    t.integer "interview_project_id"
    t.integer "interview_motivation_id"
    t.integer "interview_culture_id"
    t.integer "interview_argument_id"
    t.index ["attitude_id"], name: "index_candidates_on_attitude_id"
    t.index ["attributed_to_id"], name: "index_candidates_on_attributed_to_id"
    t.index ["baccalaureat_id"], name: "index_candidates_on_baccalaureat_id"
    t.index ["evaluated_by_id"], name: "index_candidates_on_evaluated_by_id"
    t.index ["intention_id"], name: "index_candidates_on_intention_id"
    t.index ["localization_id"], name: "index_candidates_on_localization_id"
    t.index ["production_id"], name: "index_candidates_on_production_id"
  end

  create_table "modifiers", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.float "value"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.float "evaluation_scholarship_bonus"
    t.integer "interview_number_of_candidates"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "evaluator"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "baccalaureats", "baccalaureats", column: "parent_id"
  add_foreign_key "candidates", "baccalaureats"
  add_foreign_key "candidates", "users", column: "evaluated_by_id"
end
