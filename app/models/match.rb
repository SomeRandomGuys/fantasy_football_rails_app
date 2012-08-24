# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  home_team_id :integer
#  away_team_id :integer
#  start_time   :datetime
#  home_score   :integer
#  away_score   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Match < ActiveRecord::Base
end
