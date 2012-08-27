# == Schema Information
#
# Table name: fantasy_league_types
#
#  id                      :integer          not null, primary key
#  league_type_description :string(255)
#  league_type_code        :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class FantasyLeagueType < ActiveRecord::Base
  has_many :fantasy_leagues
  def description
    "#{league_type_description}"
  end
end
