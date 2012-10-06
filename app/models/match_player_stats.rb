# == Schema Information
#
# Table name: match_player_stats
#
#  id               :integer          not null, primary key
#  match_id         :integer
#  player_id        :integer
#  started          :boolean
#  goals            :integer
#  own_goals        :integer
#  assists          :integer
#  yellow_cards     :integer
#  red_cards        :integer
#  saves            :integer
#  playing_time     :integer
#  shots            :integer
#  shots_on_target  :integer
#  penalties_taken  :integer
#  penalties_scored :integer
#  penalties_saved  :integer
#  position_played  :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class MatchPlayerStats < ActiveRecord::Base
  #validates :shots, :presence => true
  
  # has_many :match, :player
  
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
