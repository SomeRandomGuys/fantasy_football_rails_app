class ApiController < ApplicationController

  force_ssl
  before_filter :authenticate
  respond_to :json, :xml

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

  # API to write a record to match_team_stats
  api :POST, "/match_team_stats.json", "Write team stats for a match"
  description "NOT IMPLEMENTED"
  example 'NOT IMPLEMENTED'

  def match_team_stats

  end


  # API to write multiple records to match_player_stats
  api :POST, "/match_player_stats.json", "Write player stats for a match"
  description "Use this method to write individual player stats for a match. Can be called with a list of one or more players for both home and away teams. 
  Refer to the example for details"
  example <<-EX
  {"match_player_stats":
    {"match_id":1,
      "away_team":
      {"team_name":"Liverpool","players":
        [{"first_name":"Steven","last_name":"Gerrard","stats":{"mins_played":90,"goals_scored":1,"shots_on_target":2}},
          {"first_name":"Fabio","last_name":"Borini","stats":{"mins_played":78,"passes_fail":1}}]
          },
          "home_team":
          {"team_name":"Arsenal","players":
            [{"first_name":"Theo","last_name":"Walcott","stats":{"mins_played":90,"goals_allowed":1,"yellow_card_count":1,"shots_on_target":2}},
              {"first_name":"Aaron","last_name":"Ramsey","stats":{"mins_played":90,"goals_allowed":1,"tackles_successful":2}}]
            }
          }
        }
  EX
  param :match_id          , Integer, :desc => "ID of match from new_match api", :required => true
  param :team_name         , String,  :desc => "Name of the team. Applies to home_team and away_team", :required => true
  param :mins_played       , Integer, :desc => "Minutes played", :required => false
  param :goals_scored      , Integer, :desc => "Number of goals scored", :required => false
  param :goals_allowed     , Integer, :desc => "Number of goals allowed by team", :required => false
  param :goal_assists      , Integer, :desc => "Number of goals assisted on", :required => false
  param :own_goals         , Integer, :desc => "Number of own goals by player", :required => false
  param :red_card_count    , Integer, :desc => "Red cards issued", :required => false
  param :yellow_card_count , Integer, :desc => "Yellow cards issued", :required => false
  param :tackles_fail      , Integer, :desc => "Unsuccessful tackles", :required => false
  param :tackles_successful, Integer, :desc => "Successful tackles", :required => false
  param :passes_fail       , Integer, :desc => "Unsuccessful passes", :required => false
  param :passess_successful, Integer, :desc => "Successful passes", :required => false
  param :shots_on_target   , Integer, :desc => "Number of shots on target", :required => false
  param :shots_off_target  , Integer, :desc => "Number of shots off target", :required => false
  param :shots_saved       , Integer, :desc => "Shots saved (applies to goalkeepers)", :required => false
  param :penalty_scored    , Integer, :desc => "Number of penalties scored", :required => false
  param :penalty_missed    , Integer, :desc => "Number of penalties missed", :required => false
  param :penalty_saved     , Integer, :desc => "Number of penalties saved (applies to goalkeepers)", :required => false
  param :dribbles_lost     , Integer, :desc => "Numb of dribbles lost", :required => false 
  param :who_scored_rating , Integer, :desc => "Bonus rating", :required => false

  def match_player_stats

    api_response = { :success => false, :error => nil, :return => nil }

    begin

      # Validate Player and Match data exists
      home_team = Team.find_by_name!(params[:match_player_stats][:home_team][:team_name])
      away_team = Team.find_by_name!(params[:match_player_stats][:away_team][:team_name])
      match = Match.find_by_id_and_home_team_id_and_away_team_id!(params[:match_player_stats][:match_id], home_team.id, away_team.id)

      # Read player stats for both home and away team 
      ["home_team", "away_team"].each do |team|
        players = params[:match_player_stats][team][:players]
        team_name = params[:match_player_stats][team][:team_name]
        players.each do |player|
          player_id = Player.find_by_name_and_team!(player[:first_name], player[:last_name], team_name).id

          match_player_stat_record = MatchPlayerStats.where(:player_id => player_id, :match_id => match.id).first_or_initialize

          # Validate that all stats are integers
          player[:stats].each do |key, value|
            # logger.info ">>>>>>>>>#{player}[:#{key}] = #{value.class}"
            raise StandardError, "#{key} for #{player[:first_name]} #{player[:last_name]} is not a Number" unless value.is_a? Integer
          end

          # Write to match_player_stats table
          match_player_stat_record[:goals_scored]       = player[:stats][:goals_scored]
          match_player_stat_record[:mins_played]        = player[:stats][:mins_played]
          match_player_stat_record[:goals_scored]       = player[:stats][:goals_scored]
          match_player_stat_record[:goals_allowed]      = player[:stats][:goals_allowed]
          match_player_stat_record[:goal_assists]       = player[:stats][:goals_assists]
          match_player_stat_record[:own_goals]          = player[:stats][:own_goals]
          match_player_stat_record[:red_card_count]     = player[:stats][:red_card_count]
          match_player_stat_record[:yellow_card_count]  = player[:stats][:yellow_card_count]
          match_player_stat_record[:tackles_fail]       = player[:stats][:tackles_fail]
          match_player_stat_record[:tackles_successful] = player[:stats][:tackles_successful]
          match_player_stat_record[:passes_fail]        = player[:stats][:passes_fail]
          match_player_stat_record[:passess_successful] = player[:stats][:passess_successful]
          match_player_stat_record[:shots_on_target]    = player[:stats][:shots_on_target]
          match_player_stat_record[:shots_off_target]   = player[:stats][:shots_off_target]
          match_player_stat_record[:shots_saved]        = player[:stats][:shots_saved]
          match_player_stat_record[:penalty_scored]     = player[:stats][:penalty_scored]
          match_player_stat_record[:penalty_missed]     = player[:stats][:penalty_missed]
          match_player_stat_record[:penalty_saved]      = player[:stats][:penalty_saved]
          match_player_stat_record[:dribbles_lost]      = player[:stats][:dribbles_lost]
          match_player_stat_record[:who_scored_rating]  = player[:stats][:who_scored_rating]

          api_response[:return] = match_player_stat_record.save!

          api_response[:success] = true
        end
      end
      rescue StandardError => e
        api_response[:error] = e.message
        api_response[:return] = nil
        api_response[:success] = false
    end

    render :json => api_response
  end


  # API to write a new record to match
  api :POST, "/new_match.json", "Create entry for a weekly matchup"
  param :home_team, String, :desc => "name of the home team.", :required => true
  param :away_team, String, :desc => "name of the away team.", :required => true
  param :home_score, String, :desc => "Final score of the home team.", :required => true
  param :away_score, String, :desc => "Final score of the away team.", :required => true
  param :start_time, String, :desc => "Match start date time.", :required => true
  description "Use this method to create/find an entry for a match. A match entry has to be created before writing player stats"
  example "POST \'https://[domain]/api/new_match.json?api_key=[your_api_key]\' \nCONTENT-TYPE: application/json \n" +
  '{"new_match":{"home_team":"Arsenal", "away_team":"Liverpool", "home_score":"3", "away_score":"1"}}'

  def new_match

    api_response = { :success => false, :error => nil, :return => nil }

    # Write a new match with scores
    begin
      home_team = Team.find_by_name!(params[:new_match][:home_team])
      away_team = Team.find_by_name!(params[:new_match][:away_team])

      api_response[:return] = Match.where(:home_team_id => home_team.id, :away_team_id => away_team.id,
        :match_date => params[:new_match][:match_date]).first_or_create!(:home_score => params[:new_match][:home_score],
        :away_score => params[:new_match][:away_score])

        api_response[:success] = true
      rescue StandardError => e
        api_response[:error] = e.message
        api_response[:success] = false
        api_response[:return] = nil
      end

      render :json => api_response
  end


  def index
    @match_stats = MatchTeamStats.all
    respond_with @match_stats
  end

  api :GET, "/:id.json", "Show Team stats for a Match"

  def show
    api_response = { :success => false, :error => nil, :return => nil }

    api_response[:return] = Match.find(params[:id])
    api_response[:success] = true
    render :json => api_response
  end


  private

  def authenticate
    if Rails.env.production?
      head :unauthorized unless params[:api_key] && params[:api_key] == "78237e4b292b20206e7b63635f"
    else
      head :unauthorized unless params[:api_key] && params[:api_key] == "FakeApiKey"
    end

  end

end

