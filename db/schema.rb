# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151117162932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "attachments", force: :cascade do |t|
    t.integer  "followup_id"
    t.string   "file_name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "attachments", ["followup_id"], name: "index_attachments_on_followup_id", using: :btree

  create_table "followups", force: :cascade do |t|
    t.integer  "line_entry_id"
    t.integer  "user_id"
    t.text     "description"
    t.integer  "percentage"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "followups", ["line_entry_id"], name: "index_followups_on_line_entry_id", using: :btree
  add_index "followups", ["user_id"], name: "index_followups_on_user_id", using: :btree

  create_table "line_entries", force: :cascade do |t|
    t.jsonb    "data"
    t.integer  "user_id"
    t.integer  "line_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "line_entries", ["line_id"], name: "index_line_entries_on_line_id", using: :btree
  add_index "line_entries", ["user_id"], name: "index_line_entries_on_user_id", using: :btree

  create_table "lines", force: :cascade do |t|
    t.string  "name"
    t.integer "user_id"
  end

  add_index "lines", ["user_id"], name: "index_lines_on_user_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "followup_id"
    t.integer  "user_id"
    t.text     "description"
    t.boolean  "completed"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "tasks", ["followup_id"], name: "index_tasks_on_followup_id", using: :btree
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "attachments", "followups"
  add_foreign_key "followups", "line_entries"
  add_foreign_key "followups", "users"
  add_foreign_key "line_entries", "lines"
  add_foreign_key "line_entries", "users"
  add_foreign_key "lines", "users"
  add_foreign_key "tasks", "followups"
  add_foreign_key "tasks", "users"
end
