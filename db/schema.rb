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

ActiveRecord::Schema.define(version: 20170313031027) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "用户信息表" do |t|
    t.string   "first_name",      limit: 40, default: "",              comment: "姓"
    t.string   "last_name",       limit: 40, default: "",              comment: "名字"
    t.integer  "organization_id"
    t.string   "o365_user_id"
    t.string   "o365_email",                                           comment: "365邮箱"
    t.string   "job_title"
    t.string   "department"
    t.string   "mobile",          limit: 30,                           comment: "手机号码"
    t.string   "business_phones",            default: ""
    t.string   "favorite_color",  limit: 20,                           comment: "喜欢的颜色"
    t.string   "username",        limit: 50,                           comment: "姓名"
    t.string   "password",                                             comment: "密码"
    t.string   "email",           limit: 70,                           comment: "邮箱"
    t.boolean  "remember_me",                                          comment: "是否记住"
    t.integer  "role_id",                                              comment: "角色id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "token_id"
    t.boolean  "is_consent",                                           comment: "是否授权"
  end

  create_table "organizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "组织表" do |t|
    t.string   "tenant_id",          limit: 80,              comment: "租户id"
    t.string   "name",               limit: 30,              comment: "组织名"
    t.string   "is_admin_consented", limit: 1,               comment: "是否被admin授权"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "用户角色表" do |t|
    t.string   "role_name",  limit: 30,              comment: "角色名称"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "session_id",               null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "用户token表" do |t|
    t.string   "gwn_refresh_token", limit: 2000,              comment: "用户graph window net 的 refresh token"
    t.string   "o365email",         limit: 50,                comment: "用户的office 365邮箱"
    t.string   "gmc_refresh_token", limit: 2000,              comment: "用户的graph microsoft refresh token"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

end
