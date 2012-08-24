class FantasyLeagueController < ApplicationController
  
  #layout 'standard'
  
  def register_league
    @fantasy_league = FantasyLeague.new(params[:fantasy_league])
    if @fantasy_league.save
      redirect_to :action => :list_fantasy_leagues 
    else
      flash[:error] = "Type can only be an integer"
      redirect_to :new_league
    end
    
  end
  
  def create_fantasy_league
    @fantasy_league = FantasyLeague.new
  end
  
  def list_fantasy_leagues
    @fantasy_leagues = FantasyLeague.all
  end
end
