class RenameLeagueIdToFantasyLeagueId < ActiveRecord::Migration
  def change
    rename_column :fantasy_managers, :league_id, :fantasy_league_id
  end
end
