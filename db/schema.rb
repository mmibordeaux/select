# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_05_04_164020) do

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
    t.float "selection_bonus"
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
    t.text "level"
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
    t.boolean "interview_bonus", default: false
    t.float "selection_note"
    t.integer "selection_position"
    t.integer "evaluation_decile"
    t.integer "interview_decile"
    t.integer "selection_decile"
    t.boolean "evaluation_selected", default: false
    t.boolean "interview_selected", default: false
    t.boolean "selection_selected", default: false
    t.boolean "promotion_selected", default: false
    t.integer "promotion_decile"
    t.integer "promotion_position"
    t.string "gender"
    t.string "baccalaureat_mention"
    t.integer "evaluations_count", default: 0
    t.jsonb "data"
    t.index ["baccalaureat_id"], name: "index_candidates_on_baccalaureat_id"
  end

  create_table "candidates_users", id: false, force: :cascade do |t|
    t.bigint "candidate_id"
    t.bigint "user_id"
    t.index ["candidate_id"], name: "index_candidates_users_on_candidate_id"
    t.index ["user_id"], name: "index_candidates_users_on_user_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "candidate_id"
    t.bigint "user_id"
    t.bigint "attitude_id"
    t.bigint "intention_id"
    t.bigint "production_id"
    t.bigint "localization_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "note"
    t.boolean "boost", default: false
    t.index ["attitude_id"], name: "index_evaluations_on_attitude_id"
    t.index ["candidate_id"], name: "index_evaluations_on_candidate_id"
    t.index ["intention_id"], name: "index_evaluations_on_intention_id"
    t.index ["localization_id"], name: "index_evaluations_on_localization_id"
    t.index ["production_id"], name: "index_evaluations_on_production_id"
    t.index ["user_id"], name: "index_evaluations_on_user_id"
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
    t.float "interview_bonus"
    t.integer "selection_number_of_candidates"
    t.float "selection_scholarship_bonus"
    t.integer "selection_gender_bonus"
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
    t.string "first_name"
    t.string "last_name"
    t.string "first_evaluation_baccalaureats"
    t.integer "first_evaluation_quota"
    t.string "second_evaluation_baccalaureats"
    t.integer "second_evaluation_quota"
    t.text "signature"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "baccalaureats", "baccalaureats", column: "parent_id"
  add_foreign_key "candidates", "baccalaureats"
  add_foreign_key "candidates_users", "candidates"
  add_foreign_key "candidates_users", "users"
  add_foreign_key "evaluations", "candidates"
  add_foreign_key "evaluations", "modifiers", column: "attitude_id"
  add_foreign_key "evaluations", "modifiers", column: "intention_id"
  add_foreign_key "evaluations", "modifiers", column: "localization_id"
  add_foreign_key "evaluations", "modifiers", column: "production_id"
  add_foreign_key "evaluations", "users"
end
