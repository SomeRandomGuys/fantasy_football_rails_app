class AddColumnDateOfBirthToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :date_of_birth, :datetime
  end
end
