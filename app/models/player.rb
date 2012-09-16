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
  
  belongs_to :team
  belongs_to :position
  
  def self.players_view(team_id='%', position_id='%')
    if team_id == "" or team_id.nil?
        team_id = '%'
    end
    if position_id == "" or position_id.nil?
      position_id = '%'
    end
    joins(:team, :position).where("players.team_id LIKE ? and players.position_id LIKE ?", team_id, position_id).includes(:team, :position)
  end
end
