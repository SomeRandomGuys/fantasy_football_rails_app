# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  home_team_id :integer
#  away_team_id :integer
#  match_date   :datetime
#  home_score   :integer
#  away_score   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Match < ActiveRecord::Base
  validates :home_team_id, :presence => true
  validates :away_team_id, :presence => true
  validates :home_score, :presence => true
  validates :away_score, :presence => true
  
  belongs_to :match_player_stats
  
  def self.matches_in_current_gameweek
    if GameWeeks.next_gameweek.nil?
      where("start_time > ?", GameWeeks.current_gameweek.game_week_deadline)
    else
      where("start_time > ? AND start_time < ?", GameWeeks.current_gameweek.game_week_deadline, GameWeeks.next_gameweek.game_week_deadline)      
    end
    
    
  end
end
