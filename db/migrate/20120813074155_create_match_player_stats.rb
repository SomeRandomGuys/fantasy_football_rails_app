class CreateMatchPlayerStats < ActiveRecord::Migration
  def change
    create_table :match_player_stats do |t|
      t.integer :match_id
      t.integer :player_id
      t.boolean :started
      t.integer :goals
      t.integer :own_goals
      t.integer :assists
      t.integer :yellow_cards
      t.integer :red_cards
      t.integer :saves
      t.integer :playing_time
      t.integer :shots
      t.integer :shots_on_target
      t.integer :penalties_taken
      t.integer :penalties_scored
      t.integer :penalties_saved
      t.integer :position_played

      t.timestamps
    end
  end
end
