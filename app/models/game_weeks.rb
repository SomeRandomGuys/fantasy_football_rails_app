# == Schema Information
#
# Table name: game_weeks
#
#  id                 :integer          not null, primary key
#  game_week_deadline :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

class GameWeeks < ActiveRecord::Base
  
  def self.current_gameweek
    self.order(:game_week_deadline).where("game_week_deadline <= ?", Date.today).last
  end
  
  def self.next_gameweek
    where("game_week_deadline > ?", Date.today).order(:game_week_deadline).first
  end
end
