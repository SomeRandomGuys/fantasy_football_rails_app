class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :code
      t.integer :league_id
      t.string :home_field
      t.string :city

      t.timestamps
    end
  end
end
