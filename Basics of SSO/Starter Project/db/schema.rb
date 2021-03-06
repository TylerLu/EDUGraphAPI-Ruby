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

ActiveRecord::Schema.define(version: 20170501145527) do
  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      limit: 40, default: ""
    t.string   "last_name",       limit: 40, default: ""
    t.string   "email",           limit: 70
    t.string   "password"
    t.string   "password_digest"
    t.string   "o365_user_id"
    t.string   "o365_email"
    t.integer  "organization_id"
    t.boolean  "remember_me"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

end