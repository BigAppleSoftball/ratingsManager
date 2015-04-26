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

ActiveRecord::Schema.define(version: 20150425135649) do

  create_table "admins", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "board_members", force: true do |t|
    t.string   "email"
    t.string   "position"
    t.integer  "display_order"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "alt_email"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_division_rep"
    t.boolean  "is_committee_lead"
    t.integer  "profile_id"
    t.integer  "division_id"
    t.boolean  "is_league_admin"
    t.integer  "teamsnap_id"
    t.string   "teamsnap_name"
  end

  create_table "committees", force: true do |t|
    t.string   "email"
    t.integer  "profile_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.integer  "season_id"
    t.string   "description"
    t.integer  "div_order"
    t.integer  "team_cap"
    t.integer  "waitlist_cap"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", force: true do |t|
    t.string   "name"
    t.integer  "park_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_attendances", force: true do |t|
    t.integer  "profile_id"
    t.integer  "game_id"
    t.boolean  "is_attending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.integer  "day_id"
    t.datetime "start_time"
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.boolean  "is_flip"
    t.integer  "home_score"
    t.integer  "away_score"
    t.boolean  "is_rainout"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "field_id"
  end

  create_table "hallof_famers", force: true do |t|
    t.integer  "profile_id"
    t.datetime "date_inducted"
    t.boolean  "is_active"
    t.boolean  "is_inducted"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image_url"
    t.integer  "display_order"
  end

  create_table "offers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image"
    t.string   "link"
    t.string   "google_map_url"
    t.string   "company_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parks", force: true do |t|
    t.integer  "status"
    t.string   "name"
    t.string   "url"
    t.text     "google_map_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.text     "by_car"
    t.text     "by_bus"
    t.text     "by_train"
    t.text     "parking"
    t.boolean  "is_active"
    t.string   "state"
    t.float    "lat",            limit: 24
    t.float    "long",           limit: 24
  end

  create_table "profiles", force: true do |t|
    t.string   "profile_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "display_name"
    t.integer  "player_number"
    t.string   "gender"
    t.string   "shirt_size"
    t.string   "address"
    t.string   "state"
    t.integer  "zip"
    t.string   "phone"
    t.string   "position"
    t.string   "dob"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "long_image_url"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "is_admin"
  end

  create_table "ratings", force: true do |t|
    t.integer  "profile_id"
    t.datetime "date_rated"
    t.datetime "date_approved"
    t.integer  "rated_by_profile_id"
    t.integer  "approved_by_profile_id"
    t.boolean  "is_provisional"
    t.boolean  "is_approved"
    t.boolean  "is_active"
    t.integer  "rating_1"
    t.integer  "rating_2"
    t.integer  "rating_3"
    t.integer  "rating_4"
    t.integer  "rating_5"
    t.integer  "rating_6"
    t.integer  "rating_7"
    t.integer  "rating_8"
    t.integer  "rating_9"
    t.integer  "rating_10"
    t.integer  "rating_11"
    t.integer  "rating_12"
    t.integer  "rating_13"
    t.integer  "rating_14"
    t.integer  "rating_15"
    t.integer  "rating_16"
    t.integer  "rating_17"
    t.integer  "rating_18"
    t.integer  "rating_19"
    t.integer  "rating_20"
    t.integer  "rating_21"
    t.integer  "rating_22"
    t.integer  "rating_23"
    t.integer  "rating_24"
    t.integer  "rating_25"
    t.integer  "rating_26"
    t.integer  "rating_27"
    t.integer  "ng"
    t.integer  "nr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rosters", force: true do |t|
    t.integer  "team_id"
    t.integer  "profile_id"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.boolean  "is_approved"
    t.boolean  "is_player"
    t.boolean  "is_rep"
    t.boolean  "is_manager"
    t.boolean  "is_active"
    t.boolean  "is_confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: true do |t|
    t.integer  "league_id"
    t.string   "description"
    t.datetime "date_start"
    t.datetime "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active"
  end

  create_table "sponsors", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "email"
    t.string   "phone"
    t.text     "details"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_league"
    t.boolean  "show_carousel"
    t.string   "logo_url"
  end

  create_table "teams", force: true do |t|
    t.integer  "division_id"
    t.string   "long_name"
    t.integer  "stat_loss"
    t.integer  "stat_win"
    t.integer  "stat_play"
    t.integer  "stat_pt_allowed"
    t.integer  "stat_pt_scored"
    t.integer  "stat_tie"
    t.text     "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "win_perc"
    t.integer  "stat_games_back"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.datetime "date_approved"
    t.integer  "created_user_id"
    t.integer  "updated_user_id"
  end

  create_table "teams_sponsors", force: true do |t|
    t.integer  "team_id"
    t.integer  "sponsor_id"
    t.boolean  "is_active"
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teamsnap_payments", force: true do |t|
    t.integer  "teamsnap_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teamsnap_player_name"
    t.string   "teamsnap_player_email"
  end

  create_table "teamsnap_payments_syncs", force: true do |t|
    t.string   "run_by"
    t.boolean  "is_success"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_paid_players"
    t.integer  "total_unpaid_players"
    t.integer  "total_players"
    t.integer  "total_players_updated"
  end

  create_table "teamsnap_scan_accounts", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
