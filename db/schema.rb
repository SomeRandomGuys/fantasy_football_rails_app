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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121020235231) do

  create_table "fantasy_league_types", :force => true do |t|
    t.string   "league_type_description"
    t.string   "league_type_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_leagues", :force => true do |t|
    t.string   "name"
    t.integer  "league_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_user"
  end

  create_table "fantasy_managers", :force => true do |t|
    t.integer  "fantasy_league_id"
    t.string   "name"
    t.integer  "type"
    t.boolean  "commish"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_score_multipliers", :force => true do |t|
    t.integer  "fantasy_league_id"
    t.integer  "position_id"
    t.decimal  "mins_played"
    t.decimal  "goals_scored"
    t.decimal  "goals_allowed"
    t.decimal  "goal_assists"
    t.decimal  "own_goals"
    t.decimal  "red_card_count"
    t.decimal  "yellow_card_count"
    t.decimal  "tackles_fail"
    t.decimal  "tackles_successful"
    t.decimal  "passes_fail"
    t.decimal  "passess_successful"
    t.decimal  "shots_on_target"
    t.decimal  "shots_off_target"
    t.decimal  "shots_saved"
    t.decimal  "penalty_scored"
    t.decimal  "penalty_missed"
    t.decimal  "penalty_saved"
    t.decimal  "dribbles_lost"
    t.decimal  "who_scored_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_teams", :force => true do |t|
    t.integer  "fantasy_manager_id"
    t.integer  "player_id"
    t.boolean  "active_flg"
    t.datetime "added_on"
    t.datetime "dropped_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_weekly_matchups", :force => true do |t|
    t.integer  "fantasy_league_id"
    t.integer  "fantasy_home_team_id"
    t.integer  "fantasy_away_team_id"
    t.integer  "game_week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fantasy_weekly_scores", :force => true do |t|
    t.integer  "fantasy_team_id"
    t.integer  "player_id"
    t.integer  "game_week_id"
    t.decimal  "total_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_weeks", :force => true do |t|
    t.datetime "game_week_deadline"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mins_played"
    t.integer  "goals_scored"
    t.integer  "goals_allowed"
    t.integer  "goal_assists"
    t.integer  "own_goals"
    t.integer  "red_card_count"
    t.integer  "yellow_card_count"
    t.integer  "tackles_fail"
    t.integer  "tackles_successful"
    t.integer  "passes_fail"
    t.integer  "passess_successful"
    t.integer  "shots_on_target"
    t.integer  "shots_off_target"
    t.integer  "shots_saved"
    t.integer  "penalty_scored"
    t.integer  "penalty_missed"
    t.integer  "penalty_saved"
    t.integer  "dribbles_lost"
    t.decimal  "who_scored_rating"
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
    t.datetime "match_date"
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
    t.datetime "date_of_birth"
  end

  create_table "positions", :force => true do |t|
    t.string   "position"
    t.string   "field_position"
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

  create_table "user_fantasy_managers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "fantasy_manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
    t.string   "email"
  end

end
