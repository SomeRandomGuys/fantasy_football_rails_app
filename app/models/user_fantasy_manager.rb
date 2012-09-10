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
end
