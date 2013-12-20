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

ActiveRecord::Schema.define(version: 20131220181608) do

  create_table "cities", force: true do |t|
    t.string   "name"
    t.string   "state"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["latitude", "longitude"], name: "index_cities_on_latitude_and_longitude", unique: true, using: :btree
  add_index "cities", ["name", "state", "country"], name: "index_cities_on_name_and_state_and_country", unique: true, using: :btree

  create_table "clicks", force: true do |t|
    t.integer  "redirect_id"
    t.string   "user_agent"
    t.string   "browser"
    t.string   "version"
    t.string   "platform"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "ip_address"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clicks", ["city_id"], name: "index_clicks_on_city_id", using: :btree
  add_index "clicks", ["redirect_id"], name: "index_clicks_on_redirect_id", using: :btree

  create_table "redirects", force: true do |t|
    t.string   "target"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redirects", ["slug"], name: "index_redirects_on_slug", unique: true, using: :btree
  add_index "redirects", ["target", "user_id"], name: "index_redirects_on_target_and_user_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
