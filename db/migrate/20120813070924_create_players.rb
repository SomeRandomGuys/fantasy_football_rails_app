class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.integer :position_id
      t.integer :team_id
      t.string :country
      t.integer :age

      t.timestamps
    end
  end
end
