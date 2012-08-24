# == Schema Information
#
# Table name: fantasy_managers
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  name       :string(255)
#  type       :integer
#  commish    :boolean
#  created_at :datetime
#  updated_at :datetime
#

class FantasyManagers < ActiveRecord::Base
end
