# == Schema Information
#
# Table name: fantasy_weekly_matchups
#
#  id                   :integer          not null, primary key
#  fantasy_league_id    :integer
#  fantasy_home_team_id :integer
#  fantasy_away_team_id :integer
#  game_week_id         :integer
#  created_at           :datetime
#  updated_at           :datetime
#

class FantasyWeeklyMatchups < ActiveRecord::Base
end
