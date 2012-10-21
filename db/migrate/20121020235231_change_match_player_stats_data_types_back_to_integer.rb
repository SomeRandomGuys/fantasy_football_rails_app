class ChangeMatchPlayerStatsDataTypesBackToInteger < ActiveRecord::Migration
  def change
  	change_table :match_player_stats do |t|
  		t.change :mins_played,        :integer
		t.change :goals_scored,       :integer
		t.change :goals_allowed,      :integer
		t.change :goal_assists,       :integer
		t.change :own_goals,          :integer
		t.change :red_card_count,     :integer
		t.change :yellow_card_count,  :integer
		t.change :tackles_fail,       :integer
		t.change :tackles_successful, :integer
		t.change :passes_fail,        :integer
		t.change :passess_successful, :integer
		t.change :shots_on_target,    :integer
		t.change :shots_off_target,   :integer
		t.change :shots_saved,        :integer
		t.change :penalty_scored,     :integer
		t.change :penalty_missed,     :integer
		t.change :penalty_saved,      :integer
		t.change :dribbles_lost,      :integer
	end
  end
end
