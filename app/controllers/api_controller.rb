class ApiController < ApplicationController
  
  respond_to :json, :xml
  
  resource_description do
    name 'Read and Write Match Stats'
    short 'Site members'
    path '/api'
    version '1.0'
    formats ['json', 'xml']
    description <<-DOC
      Use methods described to look up team_ids, player_ids as well as write stats for weekly matchs
    DOC
  end
  
  api :POST, "/match_team_stats", "Write team stats for a match"
  def match_team_stats
    @match_stats = MatchTeamStats.new(params[:match_team_stats])
    @match_stats.save
    respond_with @match_stats 
  end
  
  api :POST, "/match_player_stats", "Write player stats for a match"
  def match_player_stats
    
  end
  
  api :POST, "/new_match", "Write a new match"
  param :home_team_id, String, :desc => "team_id of the home team. This is Required"
  param :away_team_id, String, :desc => "team_id of the away team. This is Required"
  param :home_score, String, :desc => "Final score of the home team. This is Required"
  param :away_score, String, :desc => "Final score of the away team. This is Required"
  param :start_time, String, :desc => "Match start date time. This is Required"
  description "Use this method to create an entry for a match. A match entry has to be created before writing player stats"
  example 'POST \'/api/new_match.json\'
    CONTENT-TYPE: application/json 
    {"new_match":{"home_team_id":"2", "away_team_id":"3", "home_score":"3", "away_score":"1"}}'
  def new_match
    @match = Match.new(params[:new_match])
    @match.save
    respond_with @match
  end
  
  def index
    @match_stats = MatchTeamStats.all
    respond_with @match_stats
  end
  
  api :GET, "/:id", "Show Team stats for a Match"
  def show
    @match_stats = MatchTeamStats.find(params[:id])
    respond_with @match_stats
  end
  
end
