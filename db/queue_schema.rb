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

ActiveRecord::Schema[7.2].define(version: 2026_07_22_144113) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "diagnosis_answers", force: :cascade do |t|
    t.bigint "diagnosis_question_id", null: false
    t.bigint "diagnosis_result_id", null: false
    t.integer "answer_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosis_question_id"], name: "index_diagnosis_answers_on_diagnosis_question_id"
    t.index ["diagnosis_result_id"], name: "index_diagnosis_answers_on_diagnosis_result_id"
  end

  create_table "diagnosis_questions", force: :cascade do |t|
    t.text "question_text", null: false
    t.integer "question_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diagnosis_results", force: :cascade do |t|
    t.integer "cost_score"
    t.integer "facility_score"
    t.integer "care_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities", force: :cascade do |t|
    t.integer "monthly_fee_min"
    t.integer "monthly_fee_max"
    t.integer "capacity"
    t.string "room_type"
    t.integer "care_level"
    t.string "services"
    t.string "features"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "facility_type"
    t.string "address"
    t.string "phone"
    t.string "website_url"
  end

  create_table "facility_matches", force: :cascade do |t|
    t.bigint "diagnosis_result_id", null: false
    t.bigint "facility_id", null: false
    t.integer "match_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosis_result_id"], name: "index_facility_matches_on_diagnosis_result_id"
    t.index ["facility_id"], name: "index_facility_matches_on_facility_id"
  end

  add_foreign_key "diagnosis_answers", "diagnosis_questions"
  add_foreign_key "diagnosis_answers", "diagnosis_results"
  add_foreign_key "facility_matches", "diagnosis_results"
  add_foreign_key "facility_matches", "facilities"
end
