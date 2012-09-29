class FantasyManagersController < ApplicationController
  def new

  end

  def create
    @fantasy_manager = FantasyManagers.new(params[:fantasy_managers])
    @fantasy_manager.commish = params[:commish]
    @title = 'fantasy_teams'
    if @fantasy_manager.save

      #Associate created fantasy_manager with current user
      user_fantasy_manager = UserFantasyManager.new
      user_fantasy_manager.user_id = current_user_id
      user_fantasy_manager.fantasy_manager_id = FantasyManagers.fantasy_manager_id(params[:fantasy_managers][:league_id], params[:fantasy_managers][:name])
      user_fantasy_manager.save

      redirect_to :list_fantasy_managers
    else
      flash[:error] = "Error joining a league"
      redirect_to :join_league
    end
  end
  
  def new
    @fantasy_manager = FantasyManagers.new
    @title = 'fantasy_teams'
    if params[:league_id].nil?
      @fantasy_league = FantasyLeague.leagues_for_user_id(current_user_id)
    else 
      @fantasy_league = FantasyLeague.leagues_for_user_id_and_league_id(current_user_id, params[:league_id])
    end
  end

  def show
    @fantasy_managers = FantasyManagers.managers_for_user_id(current_user_id)
    @title = 'fantasy_teams'
  end
  

end
