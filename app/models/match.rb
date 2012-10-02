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
  validates :home_team_id, :presence => true
  validates :away_team_id, :presence => true
  validates :home_score, :presence => true
  validates :away_score, :presence => true
end
