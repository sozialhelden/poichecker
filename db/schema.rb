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

ActiveRecord::Schema.define(version: 20140902121726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
    t.integer  "osm_id"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "email",                                                                           default: "", null: false
    t.string   "encrypted_password",                                                              default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                                                   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "osm_username"
    t.integer  "changeset_id",           limit: 8
    t.integer  "role_id"
    t.spatial  "location",               limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end

  add_index "admin_users", ["osm_id"], :name => "index_admin_users_on_osm_id", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "candidates", force: true do |t|
    t.integer  "place_id"
    t.float    "lat"
    t.float    "lon"
    t.string   "name"
    t.string   "housenumber"
    t.string   "street"
    t.string   "postcode"
    t.string   "city"
    t.string   "website"
    t.string   "phone"
    t.string   "wheelchair"
    t.integer  "osm_id",      limit: 8
    t.string   "osm_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "changesets", force: true do |t|
    t.integer  "osm_id",        limit: 8, null: false
    t.integer  "admin_user_id",           null: false
    t.integer  "data_set_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "changesets", ["admin_user_id"], :name => "index_changesets_on_admin_user_id"
  add_index "changesets", ["data_set_id"], :name => "index_changesets_on_data_set_id"

  create_table "data_sets", force: true do |t|
    t.string   "name"
    t.string   "license"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "mappings", force: true do |t|
    t.string   "locale",         null: false
    t.string   "localized_name", null: false
    t.string   "osm_key"
    t.string   "osm_value"
    t.boolean  "plural"
    t.string   "operator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.integer  "data_set_id"
    t.integer  "original_id"
    t.integer  "osm_id",      limit: 8
    t.string   "osm_key"
    t.string   "osm_value"
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.string   "street"
    t.string   "housenumber"
    t.string   "postcode"
    t.string   "city"
    t.string   "country"
    t.string   "website"
    t.string   "phone"
    t.string   "wheelchair"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "osm_type"
    t.integer  "matcher_id"
    t.spatial  "location",    limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer  "skips_count",                                                          default: 0
  end

  add_index "places", ["location"], :name => "index_places_on_location", :spatial => true

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skips", force: true do |t|
    t.integer  "admin_user_id", null: false
    t.integer  "place_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skips", ["admin_user_id"], :name => "index_skips_on_admin_user_id"
  add_index "skips", ["place_id"], :name => "index_skips_on_place_id"

end
