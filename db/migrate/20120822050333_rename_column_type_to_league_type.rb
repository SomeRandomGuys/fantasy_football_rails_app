class RenameColumnTypeToLeagueType < ActiveRecord::Migration
  def up
    rename_column :fantasy_leagues, :type, :league_type
  end

  def down
  end
end
