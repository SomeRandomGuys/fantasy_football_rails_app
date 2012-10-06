class CreateFantasyWeeklyScores < ActiveRecord::Migration
  def change
    create_table :fantasy_weekly_scores do |t|
      t.integer :fantasy_team_id
      t.integer :player_id
      t.integer :game_week_id
      t.decimal :total_score

      t.timestamps
    end
  end
end
