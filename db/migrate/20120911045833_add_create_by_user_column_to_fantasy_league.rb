class AddCreateByUserColumnToFantasyLeague < ActiveRecord::Migration
  def change
    add_column :fantasy_leagues, :created_by_user, :integer
  end
end
