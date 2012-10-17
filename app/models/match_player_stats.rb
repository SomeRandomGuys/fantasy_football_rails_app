# == Schema Information
#
# Table name: match_player_stats
#
#  id                 :integer          not null, primary key
#  match_id           :integer
#  player_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  mins_played        :decimal(, )
#  goals_scored       :decimal(, )
#  goals_allowed      :decimal(, )
#  goal_assists       :decimal(, )
#  own_goals          :decimal(, )
#  red_card_count     :decimal(, )
#  yellow_card_count  :decimal(, )
#  tackles_fail       :decimal(, )
#  tackles_successful :decimal(, )
#  passes_fail        :decimal(, )
#  passess_successful :decimal(, )
#  shots_on_target    :decimal(, )
#  shots_off_target   :decimal(, )
#  shots_saved        :decimal(, )
#  penalty_scored     :decimal(, )
#  penalty_missed     :decimal(, )
#  penalty_saved      :decimal(, )
#  dribbles_lost      :decimal(, )
#  who_scored_rating  :decimal(, )
#

class MatchPlayerStats < ActiveRecord::Base
  #validates :shots, :presence => true
  
  has_many :matches
  has_many :players
  after_initialize :init
  
  def self.weekly_player_stats(player_id, gameweek = GameWeeks.current_gameweek)
    matche_ids = Match.select(:id).matches_in_current_gameweek
    where(:player_id => player_id, :match_id => match_ids) 
  end
end


def init
	self.mins_played 		||= 0
	self.goals_scored 		||= 0
	self.goals_allowed      ||= 0
	self.goal_assists       ||= 0
	self.own_goals          ||= 0
	self.red_card_count     ||= 0
	self.yellow_card_count  ||= 0
	self.tackles_fail       ||= 0
	self.tackles_successful ||= 0
	self.passes_fail        ||= 0
	self.passess_successful ||= 0
	self.shots_on_target    ||= 0
	self.shots_off_target   ||= 0
	self.shots_saved        ||= 0
	self.penalty_scored     ||= 0
	self.penalty_missed     ||= 0
	self.penalty_saved      ||= 0
	self.dribbles_lost      ||= 0
	self.who_scored_rating  ||= 0
end