class PlayersController < ApplicationController
  
  def show

      #@players_view = PlayersView.new
      #@players = Player.order("country")      
    @players = Player.players_view
    @teams = Team.order("name")
    @positions = Position.all
    @title = 'players'
  end
  
  def create
    @players = Player.players_view(params[:team][:team_id], params[:position][:position_id])
    @teams = Team.order("name")
    @positions = Position.all
    @title = 'players'
    render :show
  end
  
end
