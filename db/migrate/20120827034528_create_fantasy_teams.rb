class CreateFantasyTeams < ActiveRecord::Migration
  def change
    create_table :fantasy_teams do |t|
      t.integer :fantasy_manager_id
      t.integer :player_id
      t.boolean :active_flg
      t.datetime :added_on
      t.datetime :dropped_on

      t.timestamps
    end
  end
end
