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

ActiveRecord::Schema.define(version: 20160623163518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "link_clicks", force: :cascade do |t|
    t.integer  "link_id"
    t.string   "ip"
    t.decimal  "lat",                      precision: 15, scale: 10
    t.decimal  "lng",                      precision: 15, scale: 10
    t.string   "device"
    t.string   "platform"
    t.string   "platform_version"
    t.string   "operating_system"
    t.string   "operating_system_version"
    t.string   "engine"
    t.string   "engine_version"
    t.string   "browser"
    t.string   "browser_version"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "country"
  end

  add_index "link_clicks", ["browser"], name: "index_link_clicks_on_browser", using: :btree
  add_index "link_clicks", ["country"], name: "index_link_clicks_on_country", using: :btree
  add_index "link_clicks", ["device"], name: "index_link_clicks_on_device", using: :btree
  add_index "link_clicks", ["engine"], name: "index_link_clicks_on_engine", using: :btree
  add_index "link_clicks", ["lat", "lng"], name: "index_link_clicks_on_lat_and_lng", using: :btree
  add_index "link_clicks", ["link_id"], name: "index_link_clicks_on_link_id", using: :btree
  add_index "link_clicks", ["operating_system"], name: "index_link_clicks_on_operating_system", using: :btree
  add_index "link_clicks", ["platform"], name: "index_link_clicks_on_platform", using: :btree

  create_table "links", force: :cascade do |t|
    t.string   "url"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "expiration_date"
    t.string   "title"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "links", ["slug"], name: "index_links_on_slug", unique: true, using: :btree
  add_index "links", ["user_id"], name: "index_links_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "link_clicks", "links"
  add_foreign_key "links", "users"
end
