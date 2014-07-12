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

ActiveRecord::Schema.define(version: 20140623215842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "comics", force: true do |t|
    t.integer  "number"
    t.text     "title"
    t.text     "safe_title"
    t.text     "alt_text"
    t.text     "transcript"
    t.datetime "date_published"
    t.text     "news"
    t.text     "special_link"
    t.text     "img_url"
    t.integer  "viewcount"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comics", ["number"], name: "index_comics_on_number", using: :btree

  create_table "destinations", force: true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.datetime "tested_at"
    t.string   "klass"
    t.hstore   "settings",   default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "destinations", ["user_id"], name: "index_destinations_on_user_id", using: :btree

  create_table "favourites", force: true do |t|
    t.integer  "user_id"
    t.integer  "favable_id"
    t.string   "favable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favourites", ["favable_type", "favable_id"], name: "index_favourites_on_favable_type_and_favable_id", using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree

  create_table "outbound_comics", force: true do |t|
    t.integer  "schedule_id"
    t.integer  "comic_id"
    t.datetime "sent_at"
    t.integer  "destination_ids", default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "outbound_comics", ["schedule_id"], name: "index_outbound_comics_on_schedule_id", using: :btree

  create_table "schedules", force: true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.datetime "activated_at"
    t.integer  "send_count",      default: 0
    t.datetime "next_send_at"
    t.string   "klass"
    t.hstore   "settings",        default: {}, null: false
    t.integer  "destination_ids", default: [],              array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["activated_at", "next_send_at"], name: "index_schedules_on_activated_at_and_next_send_at", using: :btree
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
