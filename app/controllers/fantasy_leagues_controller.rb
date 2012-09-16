class FantasyLeaguesController < ApplicationController

  def create
    @fantasy_league = FantasyLeague.new(params[:fantasy_league])
    @fantasy_league.created_by_user = current_user_id
    if @fantasy_league.save
      redirect_to :show
    else
      flash[:error] = "Error during league creation"
      redirect_to :new_league
    end
    
  end
  
  def new
    @fantasy_league = FantasyLeague.new
    @fantasy_league_types = FantasyLeagueType.all
  end
  
  # def list_fantasy_leagues
  def show
    @fantasy_leagues = FantasyLeague.leagues_for_user_id(current_user_id)
  end
  
  #Create a new fantasy_manager
  # def new_fantasy_manager
    # @fantasy_manager = FantasyManagers.new(params[:fantasy_managers])
    # @fantasy_manager.commish = params[:commish]
    # if @fantasy_manager.save
#       
      # #Associate created fantasy_manager with current user
      # user_fantasy_manager = UserFantasyManager.new
      # user_fantasy_manager.user_id = current_user_id
      # user_fantasy_manager.fantasy_manager_id = FantasyManagers.fantasy_manager_id(params[:fantasy_managers][:league_id], params[:fantasy_managers][:name])
      # user_fantasy_manager.save 
#       
      # redirect_to :action => :list_managers
    # else
      # flash[:error] = "Error joining a league"
      # redirect_to :join_league
    # end
  # end
#   
  # # def join_league
  # def new
    # @fantasy_manager = FantasyManagers.new
    # @fantasy_league = params[:league_id] ? FantasyLeague.find(params[:league_id]) : FantasyLeague.leagues_for_user_id(current_user_id)
  # end
  
  # def list_managers
    # @fantasy_managers = FantasyManagers.managers_for_user_id(current_user_id)
  # end
end
