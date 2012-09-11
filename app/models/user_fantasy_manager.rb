# == Schema Information
#
# Table name: user_fantasy_managers
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  fantasy_manager_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class UserFantasyManager < ActiveRecord::Base
  
  has_many :users
  has_many :fantasy_managers

  def self.list_of_managers_for_user_id(user_id)
    record_set = where("user_id = ?", user_id)
    manager_ids = []
    record_set.each do |rec|
      manager_ids.push(rec.fantasy_manager_id)
    end
    return manager_ids
  end

end
