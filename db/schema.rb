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

ActiveRecord::Schema.define(version: 20181213011741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "edo_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.string "role"
    t.integer "invited_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_edo_memberships_on_group_id"
    t.index ["invited_by"], name: "index_edo_memberships_on_invited_by"
    t.index ["user_id"], name: "index_edo_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "group_id"
    t.string "group_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "contact"
    t.string "phone"
    t.string "email"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_leads_on_email"
    t.index ["user_id"], name: "index_leads_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "notification_id"
    t.string "notification_type"
    t.datetime "notified_at"
    t.integer "notified_by_id"
    t.integer "comm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_notifications_on_group_id"
    t.index ["notification_id", "notification_type"], name: "index_notifications_on_notification_id_and_notification_type"
    t.index ["notified_by_id"], name: "index_notifications_on_notified_by_id"
  end

  create_table "restrictions", force: :cascade do |t|
    t.string "restriction_type"
    t.string "restrictions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_restrictions_on_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.boolean "verified"
    t.string "code"
    t.datetime "code_created_at"
    t.string "status"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "edo_memberships", "groups"
  add_foreign_key "edo_memberships", "users"
  add_foreign_key "edo_memberships", "users", column: "invited_by"
  add_foreign_key "leads", "users"
  add_foreign_key "notifications", "groups"
  add_foreign_key "notifications", "users", column: "notified_by_id"
  add_foreign_key "restrictions", "groups"
end
