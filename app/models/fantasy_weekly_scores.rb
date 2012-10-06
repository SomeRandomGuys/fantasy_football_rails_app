# == Schema Information
#
# Table name: fantasy_weekly_scores
#
#  id              :integer          not null, primary key
#  fantasy_team_id :integer
#  player_id       :integer
#  game_week_id    :integer
#  total_score     :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#

class FantasyWeeklyScores < ActiveRecord::Base
  
  def update_weekly_scores
    fantasy_players = self.where("game_week_id = ? AND total_score is NULL", GameWeeks.current_gameweek.id)
    fantasy_players.each do |player|
      player.total_score = calc_total_score(player.fantasy_team_id, player.player_id)
      player.save 
    end 
  end
  
  private  
  
  def calc_total_score(fantasy_team_id, player_id)
    fantasy_league_id = FantasyTeam.find(fantasy_team_id).fantasy_league_id
    position_id = Player.find(payer_id).position_id
    multipliers = FantasyScoreMultpliers.where("position_id = ? AND fantasy_league_id = ?", position_id, fantasy_league_id)
    player_stats = MatchPlayerStats.weekly_player_stats(player_id)
    
    # calculate total score
    total_score = 10 # to do
  end
    
end
