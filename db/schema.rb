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

ActiveRecord::Schema.define(version: 2022_02_20_020249) do

  create_table "branches", force: :cascade do |t|
    t.integer "company_id"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "display_day", default: 1
    t.time "start_of_business_hours"
    t.time "end_of_business_hours"
    t.integer "period_type", default: 0
    t.boolean "cross_day", default: false
    t.index ["company_id", "name"], name: "index_branches_on_company_id_and_name", unique: true
    t.index ["company_id"], name: "index_branches_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "monthlies", force: :cascade do |t|
    t.integer "branch_id", null: false
    t.integer "period_id"
    t.integer "period_num", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id"], name: "index_monthlies_on_branch_id"
    t.index ["period_id"], name: "index_monthlies_on_period_id"
  end

  create_table "monthly_periods", force: :cascade do |t|
    t.integer "monthly_id", null: false
    t.integer "start_day"
    t.integer "end_day"
    t.integer "deadline_day"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["monthly_id"], name: "index_monthly_periods_on_monthly_id"
  end

  create_table "periods", force: :cascade do |t|
    t.integer "branch_id"
    t.date "deadline"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id", "deadline"], name: "index_periods_on_branch_id_and_deadline", unique: true
    t.index ["branch_id", "start_date"], name: "index_periods_on_branch_id_and_start_date", unique: true
    t.index ["branch_id"], name: "index_periods_on_branch_id"
  end

  create_table "relationship_digests", force: :cascade do |t|
    t.integer "branch_id"
    t.string "digest"
    t.boolean "used", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.index ["branch_id", "email"], name: "index_relationship_digests_on_branch_id_and_email"
    t.index ["branch_id"], name: "index_relationship_digests_on_branch_id"
    t.index ["digest"], name: "index_relationship_digests_on_digest", unique: true
    t.index ["email"], name: "index_relationship_digests_on_email"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "branch_id"
    t.integer "user_id"
    t.boolean "admin", default: false
    t.boolean "master", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id"], name: "index_relationships_on_branch_id"
    t.index ["user_id", "branch_id"], name: "index_relationships_on_user_id_and_branch_id", unique: true
    t.index ["user_id"], name: "index_relationships_on_user_id"
  end

  create_table "shift_requests", force: :cascade do |t|
    t.integer "shift_submission_id"
    t.date "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shift_submission_id", "date"], name: "index_shift_requests_on_shift_submission_id_and_date", unique: true
    t.index ["shift_submission_id"], name: "index_shift_requests_on_shift_submission_id"
  end

  create_table "shift_submissions", force: :cascade do |t|
    t.integer "period_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["period_id", "user_id"], name: "index_shift_submissions_on_period_id_and_user_id", unique: true
    t.index ["period_id"], name: "index_shift_submissions_on_period_id"
    t.index ["user_id"], name: "index_shift_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weeklies", force: :cascade do |t|
    t.integer "branch_id"
    t.integer "start_day"
    t.integer "deadline_day"
    t.integer "period_id"
    t.integer "num_of_weeks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["branch_id"], name: "index_weeklies_on_branch_id"
    t.index ["period_id"], name: "index_weeklies_on_period_id"
  end

  add_foreign_key "branches", "companies"
  add_foreign_key "monthlies", "branches"
  add_foreign_key "monthlies", "periods"
  add_foreign_key "monthly_periods", "monthlies"
  add_foreign_key "periods", "branches"
  add_foreign_key "relationship_digests", "branches"
  add_foreign_key "relationships", "branches"
  add_foreign_key "relationships", "users"
  add_foreign_key "shift_requests", "shift_submissions"
  add_foreign_key "shift_submissions", "periods"
  add_foreign_key "shift_submissions", "users"
  add_foreign_key "weeklies", "branches"
  add_foreign_key "weeklies", "periods"
end
