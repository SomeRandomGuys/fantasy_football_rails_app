# == Schema Information
#
# Table name: fantasy_teams
#
#  id                 :integer          not null, primary key
#  fantasy_manager_id :integer
#  player_id          :integer
#  active_flg         :boolean
#  added_on           :datetime
#  dropped_on         :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class FantasyTeams < ActiveRecord::Base
end
