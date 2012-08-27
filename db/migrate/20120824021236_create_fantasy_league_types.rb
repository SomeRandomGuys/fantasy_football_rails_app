class CreateFantasyLeagueTypes < ActiveRecord::Migration
  def change
    create_table :fantasy_league_types do |t|
      t.string :league_type_description
      t.string :league_type_code

      t.timestamps
    end
  end
end
