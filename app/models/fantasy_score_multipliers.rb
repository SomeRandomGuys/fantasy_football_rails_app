# == Schema Information
#
# Table name: fantasy_score_multipliers
#
#  id                 :integer          not null, primary key
#  fantasy_league_id  :integer
#  position_id        :integer
#  mins_played        :decimal(, )
#  goals_scored       :decimal(, )
#  goals_allowed      :decimal(, )
#  goal_assists       :decimal(, )
#  own_goals          :decimal(, )
#  red_card_count     :decimal(, )
#  yellow_card_count  :decimal(, )
#  tackles_fail       :decimal(, )
#  tackles_successful :decimal(, )
#  passes_fail        :decimal(, )
#  passess_successful :decimal(, )
#  shots_on_target    :decimal(, )
#  shots_off_target   :decimal(, )
#  shots_saved        :decimal(, )
#  penalty_scored     :decimal(, )
#  penalty_missed     :decimal(, )
#  penalty_saved      :decimal(, )
#  dribbles_lost      :decimal(, )
#  who_scored_rating  :decimal(, )
#  created_at         :datetime
#  updated_at         :datetime
#

class FantasyScoreMultipliers < ActiveRecord::Base
  has_many :positions
  has_many :fantasy_leagues
end
