class FantasyLeaguesController < ApplicationController

  def create
    @fantasy_league = FantasyLeague.new(params[:fantasy_league])
    @fantasy_league.created_by_user = current_user_id
    if @fantasy_league.save
      @fantasy_league.reload
      # ----TO DO ----
      # Create default score multipliers
      FantasyScoreMultipliers.create_default_scoring_for_fantasy_league(@fantasy_league.id)
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
    @title = 'fantasy_leagues'
  end

end
