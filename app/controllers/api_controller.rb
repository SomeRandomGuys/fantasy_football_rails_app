class ApiController < ApplicationController

  force_ssl
  before_filter :authenticate
  respond_to :json, :xml

  @@api_response = { :success => false, :error => nil, :return => nil }

  resource_description do
    name 'Read and Write Match Stats'
    short 'Resources'
    path '/api'
    version '1.0'
    formats ['json']
    description <<-DOC
      Use methods described to create entries for weekly matchup as well as to write player and team stats
    DOC
  end

  ############################################################################################################################
  api :POST, "/match_team_stats.json", "Write team stats for a match"
  description "NOT IMPLEMENTED"
  example 'NOT IMPLEMENTED'

  def match_team_stats

  end
  ############################################################################################################################

  ############################################################################################################################
  api :POST, "/match_player_stats.json", "Write player stats for a match"
  description "NOT IMPLEMENTED"
  example 'NOT IMPLEMENTED'

  def match_player_stats
    player = Player.find_by_name_and_team(params[:player_attrs][:first_name], \
    params[:player_attrs][:last_name], params[:player_attrs][:team])
    if player.nil?
      @@api_response[:error] = "Something went wrong"
    else
      match_player_stats = MatchPlayerStats.new()
      match_player_stats.player_id = player.id
      match_player_stats.match_id = params[:match_player_stats][:match_id]
      if match_player_stats.save
        @@api_response[:success] = true  
      else
        @@api_response[:error] = "Something went wrong"
      end
      @@api_response[:return] = match_player_stats
    end
    render :json => @@api_response
  end
  ############################################################################################################################

  ############################################################################################################################
  api :POST, "/new_match.json", "Create entry for a weekly matchup"
  param :home_team, String, :desc => "name of the home team.", :required => true
  param :away_team, String, :desc => "name of the away team.", :required => true
  param :home_score, String, :desc => "Final score of the home team.", :required => true
  param :away_score, String, :desc => "Final score of the away team.", :required => true
  param :start_time, String, :desc => "Match start date time.", :required => true
  description "Use this method to create an entry for a match. A match entry has to be created before writing player stats"
  example "POST \'https://[domain]/api/new_match.json?api_key=[your_api_key]\' \nCONTENT-TYPE: application/json \n" +
    '{"new_match":{"home_team":"Arsenal", "away_team":"Liverpool", "home_score":"3", "away_score":"1"}}'

  def new_match
    # find teams
    home_team = Team.find_by_name(params[:new_match][:home_team])
    away_team = Team.find_by_name(params[:new_match][:away_team])

    if home_team.nil? or away_team.nil?
      @@api_response[:error] = "Invalid home team or away team"
    else
    # Write a new match with scores
      @match = Match.new()
      @match.home_team_id = home_team.id
      @match.away_team_id = away_team.id
      @match.home_score = params[:new_match][:home_score]
      @match.away_score = params[:new_match][:away_score]
      @match.save

      @@api_response[:success] = true
      @@api_response[:return] = @match
    end

    render :json => @@api_response
  end
  ############################################################################################################################

  ############################################################################################################################
  def index
    @match_stats = MatchTeamStats.all
    respond_with @match_stats
  end

  api :GET, "/:id.json", "Show Team stats for a Match"

  def show
    @@api_response[:return] = MatchTeamStats.find(params[:id])
    @@api_response[:success] = true
    render :json => @@api_response
  end
  ############################################################################################################################

  private

  def authenticate
    head :unauthorized unless params[:api_key] && params[:api_key] == "78237e4b292b20206e7b63635f"
  end

end

