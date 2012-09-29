class FantasyTeamsController < ApplicationController

  def show
    @fantasy_team = FantasyTeam.fantasy_team_by_manager_id(params[:id])
    @title = 'fantasy_teams'
  end
  
  def drop_player
    player = FantasyTeam.find_by_player_id(params[:id])
    
    player.dropped_on = Time.now
    player.active_flg = false
    player.save
    
    redirect_to '/' 
    #fantasy_team_path, :id => params[:id]  
  end
  
end
