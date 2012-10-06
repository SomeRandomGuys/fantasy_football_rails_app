class CreateFantasyWeeklyMatchups < ActiveRecord::Migration
  def change
    create_table :fantasy_weekly_matchups do |t|
      t.integer :fantasy_league_id
      t.integer :fantasy_home_team_id
      t.integer :fantasy_away_team_id
      t.integer :game_week_id

      t.timestamps
    end
  end
end
