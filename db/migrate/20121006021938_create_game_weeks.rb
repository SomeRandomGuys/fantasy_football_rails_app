class CreateGameWeeks < ActiveRecord::Migration
  def change
    create_table :game_weeks do |t|
      t.datetime :game_week_deadline

      t.timestamps
    end
  end
end
