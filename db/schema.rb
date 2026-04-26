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
ActiveRecord::Schema[8.0].define(version: 2025_12_13_110643) do
  create_table "billing_records", force: :cascade do |t|
    t.integer "client_id", null: false
    t.datetime "billed_at"
    t.string "payment_method_identifier"
    t.string "status"
    t.string "year_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id", "year_month"], name: "index_billing_records_on_client_id_and_year_month", unique: true
    t.index ["client_id"], name: "index_billing_records_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.integer "due_day"
    t.string "payment_method_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "billing_records", "clients"
  add_foreign_key "sessions", "users"
end
