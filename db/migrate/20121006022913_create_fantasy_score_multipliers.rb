class CreateFantasyScoreMultipliers < ActiveRecord::Migration
  def change
    create_table :fantasy_score_multipliers do |t|
      t.integer :fantasy_league_id
      t.integer :position_id
      t.decimal :mins_played
      t.decimal :goals_scored
      t.decimal :goals_allowed
      t.decimal :goal_assists
      t.decimal :own_goals
      t.decimal :red_card_count
      t.decimal :yellow_card_count
      t.decimal :tackles_fail
      t.decimal :tackles_successful
      t.decimal :passes_fail
      t.decimal :passess_successful
      t.decimal :shots_on_target
      t.decimal :shots_off_target
      t.decimal :shots_saved
      t.decimal :penalty_scored
      t.decimal :penalty_missed
      t.decimal :penalty_saved
      t.decimal :dribbles_lost
      t.decimal :who_scored_rating

      t.timestamps
    end
  end
end
