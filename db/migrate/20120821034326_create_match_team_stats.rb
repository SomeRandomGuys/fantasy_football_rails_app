class CreateMatchTeamStats < ActiveRecord::Migration
  def change
    create_table :match_team_stats do |t|
      t.integer :match_id
      t.integer :team_id

      t.timestamps
    end
  end
end
