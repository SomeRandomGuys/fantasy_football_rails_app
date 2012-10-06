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
  
  def self.update_weekly_scores
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
    total_score = multpliers.mins_played * player_stats.mins_played + 
                  multpliers.goals_scored * player_stats.goals_scored + 
                  multpliers.goals_allowed * player_stats.goals_allowed + 
                  multplier.own_goals * player_stats.own_goals + 
                  multplier.red_card_count * player_stats.red_card_count + 
                  multplier.yellow_card_count * player_stats.yellow_card_count + 
                  multplier.tackles_fail * player_stats.tackles_fail + 
                  multplier.tackles_successful * player_stats.tackles_successful + 
                  multplier.passes_fail * player_stats.passes_fail + 
                  multplier.passess_successful * player_stats.passess_successful + 
                  multplier.shots_on_target * player_stats.shots_on_target + 
                  multplier.shots_off_target * player_stats.shots_off_target + 
                  multplier.shots_saved * player_stats.shots_saved + 
                  multplier.penalty_scored * player_stats.penalty_scored + 
                  multplier.penalty_missed * player_stats.penalty_missed + 
                  multplier.penalty_saved * player_stats.penalty_saved + 
                  multplier.dribbles_lost * player_stats.dribbles_lost + 
                  multplier.who_scored_rating * player_stats.shots_saved
                  
  end
    
end
