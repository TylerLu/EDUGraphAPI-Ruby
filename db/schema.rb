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

  create_table "classroom_seating_arrangements", force: :cascade do |t|
    t.string   "class_id",   limit: 40
    t.string   "user_id",    limit: 40
    t.integer  "position"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["class_id", "user_id"], name: "index_classroom_seating_arrangements_on_class_id_and_user_id", unique: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "tenant_id",          limit: 80
    t.string   "name",               limit: 30
    t.boolean  "is_admin_consented", limit: 1
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",  limit: 30
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "token_caches", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "o365_userId"
    t.text     "refresh_token"
    t.text     "access_tokens"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_roles_on_user_id"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",      limit: 40, default: ""
    t.string   "last_name",       limit: 40, default: ""
    t.string   "email",           limit: 70
    t.string   "password"
    t.string   "password_digest"
    t.string   "favorite_color",  limit: 20
    t.string   "o365_user_id"
    t.string   "o365_email"
    t.integer  "organization_id"
    t.boolean  "remember_me"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

end