# == Schema Information
#
# Table name: fantasy_leagues
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  league_type :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class FantasyLeague < ActiveRecord::Base
  validates :name, :presence => true
  validates :league_type, :numericality => { :only_integer => true }
end
