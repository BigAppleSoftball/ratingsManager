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

ActiveRecord::Schema.define(version: 20150129023450) do

  create_table "divisions", force: true do |t|
    t.integer  "div_id"
    t.integer  "season_id"
    t.integer  "pool_id"
    t.string   "div_description"
    t.integer  "div_order"
    t.string   "standings"
    t.integer  "team_cap"
    t.integer  "waitlist_cap"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.string   "profile_code"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "nickname"
    t.string   "display_name"
    t.integer  "player_number"
    t.string   "gender"
    t.string   "shirt_size"
    t.string   "address"
    t.string   "state"
    t.integer  "zip"
    t.string   "phone"
    t.string   "emergency_name"
    t.string   "emergency_relation"
    t.string   "emergency_phone"
    t.string   "emergency_email"
    t.string   "position"
    t.string   "dob"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rosters", force: true do |t|
    t.integer  "team_id"
    t.integer  "profile_id"
    t.datetime "date_created"
    t.datetime "date_approved"
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
    t.integer  "season_id"
    t.integer  "league_id"
    t.integer  "pool_id"
    t.string   "season_desc"
    t.datetime "date_start"
    t.datetime "date_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsors", force: true do |t|
    t.integer  "sponsor_id"
    t.string   "name"
    t.string   "url"
    t.string   "email"
    t.string   "phone"
    t.text     "details"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.integer  "created_user_id"
    t.integer  "updated_user_id"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "teamsnap_id"
    t.text     "team_desc"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team_code"
    t.string   "team_status"
    t.string   "win_perc"
    t.integer  "stat_games_back"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.datetime "date_approved"
    t.string   "contact"
    t.string   "email"
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

end
