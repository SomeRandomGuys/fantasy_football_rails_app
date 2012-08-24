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

ActiveRecord::Schema.define(:version => 20120822050333) do

  create_table "fantasy_leagues", :force => true do |t|
    t.string   "name"
    t.integer  "league_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_managers", :force => true do |t|
    t.integer  "league_id"
    t.string   "name"
    t.integer  "type"
    t.boolean  "commish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_player_stats", :force => true do |t|
    t.integer  "match_id"
    t.integer  "player_id"
    t.boolean  "started"
    t.integer  "goals"
    t.integer  "own_goals"
    t.integer  "assists"
    t.integer  "yellow_cards"
    t.integer  "red_cards"
    t.integer  "saves"
    t.integer  "playing_time"
    t.integer  "shots"
    t.integer  "shots_on_target"
    t.integer  "penalties_taken"
    t.integer  "penalties_scored"
    t.integer  "penalties_saved"
    t.integer  "position_played"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_team_stats", :force => true do |t|
    t.integer  "match_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.datetime "start_time"
    t.integer  "home_score"
    t.integer  "away_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "position_id"
    t.integer  "team_id"
    t.string   "country"
    t.integer  "age"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.string   "position"
    t.string   "type"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "league_id"
    t.string   "home_field"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
