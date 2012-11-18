# == Schema Information
#
# Table name: fantasy_teams
#
#  id                 :integer          not null, primary key
#  fantasy_manager_id :integer
#  player_id          :integer
#  active_flg         :boolean
#  added_on           :datetime
#  dropped_on         :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class FantasyTeam < ActiveRecord::Base
  
  belongs_to :fantasy_weekly_scores
  has_many :players
  has_many :fantasy_managers
  
  def self.fantasy_team_by_manager_id(fantasy_manager_id)
    #@fantasy_team = joins(:player, :position).where("fantasy_manager_id = ? and active_flg = 1", fantasy_manager_id).includes(:player, :position)
    sql = "SELECT * FROM fantasy_teams as ft \
           INNER JOIN players as p on ft.player_id = p.id \
           INNER JOIN positions pos on p.position_id = pos.id \
           WHERE ft.fantasy_manager_id = #{fantasy_manager_id} and ft.active_flg = 1"
           
    @fantasy_team = find_by_sql(sql)
  end
  
  def fantasy_league_id
    FantasyManager.find(self.fantasy_manager_id).fantasy_league_id
  end
end
