class CreateFantasyManagers < ActiveRecord::Migration
  def change
    create_table :fantasy_managers do |t|
      t.integer :league_id
      t.string :name
      t.integer :type
      t.boolean :commish

      t.timestamps
    end
  end
end
