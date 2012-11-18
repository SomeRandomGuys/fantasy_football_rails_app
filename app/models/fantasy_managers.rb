# == Schema Information
#
# Table name: fantasy_managers
#
#  id                :integer          not null, primary key
#  fantasy_league_id :integer
#  name              :string(255)
#  type              :integer
#  commish           :boolean
#  created_at        :datetime
#  updated_at        :datetime
#

class FantasyManagers < ActiveRecord::Base
  
  validates :name, :presence => true
  validates :fantasy_league_id, :presence => true
  belongs_to :user_fantasy_manager
  
  def league_name(id)
    FantasyLeague.find(id).name
  end
  
  def self.fantasy_manager_id(fantasy_league_id, manager_name)
    #return find(id).league_id
    where("fantasy_league_id = ? AND name = ?", fantasy_league_id, manager_name).limit(1)[0].id
  end
  
  def self.managers_for_user_id(user_id)
    begin
      find(UserFantasyManager.list_of_managers_for_user_id(user_id))
    rescue
      return []
    end
  end
  
end
