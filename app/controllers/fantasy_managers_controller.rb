class FantasyManagersController < ApplicationController
  def new

  end

  def create
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
  
  def new
    @fantasy_manager = FantasyManagers.new
    @fantasy_league = params[:league_id] ? FantasyLeague.find(params[:league_id]) : FantasyLeague.leagues_for_user_id(current_user_id)
    #@fantasy_league = FantasyLeague.leagues_for_user_id(current_user_id)
  end

  def show
    @fantasy_managers = FantasyManagers.managers_for_user_id(current_user_id)
  end
  
end
