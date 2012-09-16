class RenameColumnTypeToFieldPosition < ActiveRecord::Migration
  def up
    rename_column :positions, :type, :field_position
  end

  def down
  end
end
