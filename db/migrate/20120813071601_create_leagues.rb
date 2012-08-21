class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :code
      t.string :country

      t.timestamps
    end
  end
end
