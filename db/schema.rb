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

ActiveRecord::Schema[7.2].define(version: 2026_07_31_131438) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "diagnosis_answers", force: :cascade do |t|
    t.bigint "diagnosis_question_id", null: false
    t.bigint "diagnosis_option_id", null: false
    t.string "session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diagnosis_option_id"], name: "index_diagnosis_answers_on_diagnosis_option_id"
    t.index ["diagnosis_question_id"], name: "index_diagnosis_answers_on_diagnosis_question_id"
    t.index ["session_id", "diagnosis_question_id"], name: "idx_on_session_id_diagnosis_question_id_2d63da7b8b", unique: true
  end

  create_table "diagnosis_options", force: :cascade do |t|
    t.bigint "diagnosis_question_id", null: false
    t.string "option_text", null: false
    t.integer "weight_value", null: false
    t.integer "display_order", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weight_category"
    t.index ["diagnosis_question_id"], name: "index_diagnosis_options_on_diagnosis_question_id"
  end

  create_table "diagnosis_questions", force: :cascade do |t|
    t.text "question_text", null: false
    t.integer "question_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "weight_category"
    t.integer "display_order", default: 0, null: false
  end

  create_table "diagnosis_results", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "result_title"
    t.text "result_description"
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

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.bigint "key_hash", null: false
    t.integer "byte_size", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["created_at"], name: "index_solid_cache_entries_on_created_at"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concurrency_key"], name: "index_solid_queue_blocked_executions_on_concurrency_key"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id"
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "claimed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id"
    t.index ["process_id", "claimed_at"], name: "idx_on_process_id_claimed_at_c7452699b3"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id"
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "finished_with"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["finished_at", "finished_with"], name: "index_solid_queue_jobs_on_finished_at_and_finished_with"
    t.index ["priority"], name: "index_solid_queue_jobs_on_priority"
    t.index ["queue_name"], name: "index_solid_queue_jobs_on_queue_name"
    t.index ["scheduled_at"], name: "index_solid_queue_jobs_on_scheduled_at"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_heartbeat_at", "supervisor_id"], name: "idx_on_last_heartbeat_at_supervisor_id_401ff53e96"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id"
    t.index ["priority"], name: "index_solid_queue_ready_executions_on_priority"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id"
    t.index ["scheduled_at"], name: "index_solid_queue_scheduled_executions_on_scheduled_at"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  add_foreign_key "diagnosis_answers", "diagnosis_options"
  add_foreign_key "diagnosis_answers", "diagnosis_questions"
  add_foreign_key "diagnosis_options", "diagnosis_questions"
  add_foreign_key "facility_matches", "diagnosis_results"
  add_foreign_key "facility_matches", "facilities"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id"
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id"
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id"
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id"
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id"
end
