# == Schema Information
#
# Table name: players
#
#  id          :integer          not null, primary key
#  first_name  :string(255)
#  last_name   :string(255)
#  position_id :integer
#  team_id     :integer
#  country     :string(255)
#  age         :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Player < ActiveRecord::Base
end
