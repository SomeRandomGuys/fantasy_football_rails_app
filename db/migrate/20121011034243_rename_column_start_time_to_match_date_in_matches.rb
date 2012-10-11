class RenameColumnStartTimeToMatchDateInMatches < ActiveRecord::Migration
  def change
    rename_column :matches, :start_time, :match_date
  end
end
