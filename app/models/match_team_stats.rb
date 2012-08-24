# == Schema Information
#
# Table name: match_team_stats
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  team_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class MatchTeamStats < ActiveRecord::Base
end
