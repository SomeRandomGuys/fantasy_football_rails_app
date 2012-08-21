class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.datetime :start_time
      t.integer :home_score
      t.integer :away_score

      t.timestamps
    end
  end
end
