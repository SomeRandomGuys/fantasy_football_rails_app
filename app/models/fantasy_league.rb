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
  belongs_to :fantasy_league_type
  validates :name, :presence => true
  validates :league_type, :numericality => { :only_integer => true }
  
  def league_type_description(id)
    FantasyLeagueType.find(id).league_type_description
  end
end
