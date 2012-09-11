# == Schema Information
#
# Table name: fantasy_leagues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  league_type     :integer
#  created_at      :datetime
#  updated_at      :datetime
#  created_by_user :integer
#

class FantasyLeague < ActiveRecord::Base
  belongs_to :fantasy_league_type
  validates :name, :presence => true
  validates :league_type, :numericality => { :only_integer => true }
  
  def league_type_description(id)
    FantasyLeagueType.find(id).league_type_description
  end
  
  def self.leagues_for_user_id(user_id)
    fantasy_leagues = []
    
    # Find leagues for which the user has managers
    FantasyManagers.managers_for_user_id(user_id).each do |rec|
      fantasy_leagues.push(find(rec.league_id))
    end
    
    # Also include leagues created by the users but may not have managers yet
    where(:created_by_user => user_id).each do |rec|
      fantasy_leagues.push(rec)
    end
    
    # Remove dups
    return fantasy_leagues.uniq
  end
  
  def all
    
  end
end
