# == Schema Information
#
# Table name: match_player_stats
#
#  id                 :integer          not null, primary key
#  match_id           :integer
#  player_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
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
#

class MatchPlayerStats < ActiveRecord::Base
  #validates :shots, :presence => true
  
  has_many :matches
  has_many :players
  
  def self.weekly_player_stats(player_id, gameweek = GameWeeks.current_gameweek)
    matche_ids = Match.select(:id).matches_in_current_gameweek
    where(:player_id => player_id, :match_id => match_ids) 
  end
end


# mins_played
# 
# 
# goals_allowed / clean_sheet
# tackles_fail (might not be used)
# tackles_successful
# passes_fail/passes_lost
# passess_successful
# 
# shots_off_target
# shots_saved
# 
# penalty_missed
# penalty_saved
# who_scored_rating (could be used for error correction - extra credit)
# dribbles_lost
