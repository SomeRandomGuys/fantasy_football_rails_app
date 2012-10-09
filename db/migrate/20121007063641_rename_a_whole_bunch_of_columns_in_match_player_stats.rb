class RenameAWholeBunchOfColumnsInMatchPlayerStats < ActiveRecord::Migration
  def change
    # existing columns
     remove_column :match_player_stats, :started
     remove_column :match_player_stats, :goals
     remove_column :match_player_stats, :own_goals
     remove_column :match_player_stats, :assists
     remove_column :match_player_stats, :yellow_cards
     remove_column :match_player_stats, :red_cards
     remove_column :match_player_stats, :saves
     remove_column :match_player_stats, :playing_time
     remove_column :match_player_stats, :shots
     remove_column :match_player_stats, :shots_on_target
     remove_column :match_player_stats, :penalties_taken
     remove_column :match_player_stats, :penalties_scored
     remove_column :match_player_stats, :penalties_saved
     remove_column :match_player_stats, :position_played
     
     #add columns
     add_column :match_player_stats, :mins_played,        :decimal
     add_column :match_player_stats, :goals_scored,       :decimal
     add_column :match_player_stats, :goals_allowed,      :decimal
     add_column :match_player_stats, :goal_assists,       :decimal
     add_column :match_player_stats, :own_goals,          :decimal
     add_column :match_player_stats, :red_card_count,     :decimal
     add_column :match_player_stats, :yellow_card_count,  :decimal
     add_column :match_player_stats, :tackles_fail,       :decimal
     add_column :match_player_stats, :tackles_successful, :decimal
     add_column :match_player_stats, :passes_fail,        :decimal
     add_column :match_player_stats, :passess_successful, :decimal
     add_column :match_player_stats, :shots_on_target,    :decimal
     add_column :match_player_stats, :shots_off_target,   :decimal
     add_column :match_player_stats, :shots_saved,        :decimal
     add_column :match_player_stats, :penalty_scored,     :decimal
     add_column :match_player_stats, :penalty_missed,     :decimal
     add_column :match_player_stats, :penalty_saved,      :decimal
     add_column :match_player_stats, :dribbles_lost,      :decimal
     add_column :match_player_stats, :who_scored_rating,  :decimal
     
  end
end
