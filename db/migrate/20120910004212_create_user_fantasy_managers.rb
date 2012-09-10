class CreateUserFantasyManagers < ActiveRecord::Migration
  def change
    create_table :user_fantasy_managers do |t|
      t.integer :user_id
      t.integer :fantasy_manager_id

      t.timestamps
    end
  end
end
