FactoryGirl.define do
  factory :game_weeks do
    game_week_deadline Date.today
  end
  
  factory :fantasy_league_type do
    league_type_description "Foo-to-Foo"
    league_type_code        "F2F"
  end
  
  factory :fantasy_league do
    name            "Foo-ty"
    league_type     1     
    created_by_user 1
  end
  
  factory :fantasy_team do
    association :fantasy_manager_id, factory: :fantasy_managers
    association :player_id, factory: :player
    active_flg  true
    added_on    Date.today
    dropped_on  nil
  end
  
  factory :fantasy_managers do
    association :fantasy_league_id, factory: :fantasy_league
    name        "Foo-League"
    type        1
    commish     true
  end
  
  factory :match_player_stats do
    association        :match_id, factory: :match
    association        :player_id, factory: :player
    # match_id 1
    # player_id 1
    mins_played        2
    goals_scored       2
    goals_allowed      2
    goal_assists       2
    own_goals          2
    red_card_count     2
    yellow_card_count  2
    tackles_fail       2
    tackles_successful 2
    passes_fail        2
    passess_successful 2
    shots_on_target    2
    shots_off_target   2
    shots_saved        2
    penalty_scored     2
    penalty_missed     2
    penalty_saved      2
    dribbles_lost      2
    who_scored_rating  2
  end
  
  factory :match do
    # association :home_team_id, factory: :team
    # association :away_team_id, factory: :team
    home_team_id 1
    away_team_id 2
    start_time  Date.today
    home_score  2
    away_score  2
  end
  
  factory :player do
     first_name  "Foo"
     last_name   "Bar"
     association :position_id, factory: :position
     association :team_id, factory: :team     
     country     "Fooland"
     age         25
  end
  
  factory :team do
    name      "Footypool"
    code       "FPL"
    association 1  
    home_field "Foofield"
    city        "Feattle"
  end
  
  factory :position do
    position       "Central Mid Field"
    field_position "Mid Field"
    code           "MF"
  end
  
  factory :fantasy_score_multipliers do
    association        :fantasy_league_id, factory: :fantasy_league
    association        :position_id, factory: :position
    mins_played        2
    goals_scored       2
    goals_allowed      2
    goal_assists       2
    own_goals          2
    red_card_count     2
    yellow_card_count  2
    tackles_fail       2
    tackles_successful 2
    passes_fail        2
    passess_successful 2
    shots_on_target    2
    shots_off_target   2
    shots_saved        2
    penalty_scored     2
    penalty_missed     2
    penalty_saved      2
    dribbles_lost      2
    who_scored_rating  2
  end
end
