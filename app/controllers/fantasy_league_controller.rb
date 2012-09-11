class FantasyLeagueController < ApplicationController
  
  #include SessionsHelper
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
    @fantasy_league_types = FantasyLeagueType.all
  end
  
  def list_fantasy_leagues
    @fantasy_leagues = FantasyLeague.all
  end
  
  #Create a new fantasy_manager
  def new_fantasy_manager
    @fantasy_manager = FantasyManagers.new(params[:fantasy_managers])
    @fantasy_manager.commish = params[:commish]
    if @fantasy_manager.save
      
      #Associate created fantasy_manager with current user
      user_fantasy_manager = UserFantasyManager.new
      user_fantasy_manager.user_id = current_user_id
      user_fantasy_manager.fantasy_manager_id = FantasyManagers.fantasy_manager_id(params[:fantasy_managers][:league_id], params[:fantasy_managers][:name])
      user_fantasy_manager.save 
      
      redirect_to :action => :list_managers
    else
      flash[:error] = "Error joining a league"
      redirect_to :join_league
    end
  end
  
  def join_league
    @fantasy_manager = FantasyManagers.new
    @fantasy_league = FantasyLeague.all
  end
  
  def list_managers
    @fantasy_managers = FantasyManagers.managers_for_user_id(current_user_id)
  end
end
