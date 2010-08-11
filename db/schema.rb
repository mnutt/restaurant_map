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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100811205046) do

  create_table "collections", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "public"
    t.string   "private_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.integer  "rating"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "review"
    t.datetime "last_visited_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "company"
    t.string   "tags_cache",            :default => "--- []"
    t.integer  "collection_id"
    t.integer  "foursquare_checkin_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tags", :force => true do |t|
    t.string   "name",           :limit => 64
    t.string   "model_type"
    t.integer  "tagships_count",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name", "model_type"], :name => "index_tags_on_name_and_model_type"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tagships", :force => true do |t|
    t.integer  "model_id",   :default => 0
    t.string   "model_type"
    t.integer  "tag_id",     :default => 0
    t.datetime "created_at"
  end

  add_index "tagships", ["model_id", "model_type"], :name => "index_tagships_on_model_id_and_model_type"
  add_index "tagships", ["tag_id"], :name => "index_tagships_on_tag_id"

  create_table "users", :force => true do |t|
    t.string   "name",                    :limit => 100
    t.string   "email",                                                 :null => false
    t.string   "crypted_password",                                      :null => false
    t.string   "password_salt",                                         :null => false
    t.string   "activation_code",         :limit => 40
    t.string   "persistence_token",                                     :null => false
    t.string   "single_access_token",                                   :null => false
    t.string   "perishable_token",                                      :null => false
    t.integer  "login_count",                            :default => 0, :null => false
    t.integer  "failed_login_count",                     :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "foursquare_oauth_token"
    t.string   "foursquare_oauth_secret"
  end

end
