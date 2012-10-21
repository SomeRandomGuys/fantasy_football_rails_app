# == Schema Information
#
# Table name: fantasy_score_multipliers
#
#  id                 :integer          not null, primary key
#  fantasy_league_id  :integer
#  position_id        :integer
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
#  created_at         :datetime
#  updated_at         :datetime
#

class FantasyScoreMultipliers < ActiveRecord::Base
  has_many :positions
  has_many :fantasy_leagues

  # after_initialize :set_defaults

  def self.create_default_scoring_for_fantasy_league(fantasy_league_id)
  	positions = Position.all

  	positions.each do |position|
  		position_multipliers = FantasyScoreMultipliers.new(:position_id => position.id, :fantasy_league_id => fantasy_league_id)
  		position_multipliers.set_defaults(position.code)
  		position_multipliers.save
  	end

  end

  

  def set_defaults(code)
 	case code
 	when 'GK'
	 	self.mins_played		= 2
		self.goals_scored		= 2
		self.goals_allowed		= 2
		self.goal_assists       = 2
		self.own_goals          = 2
		self.red_card_count     = 2
		self.yellow_card_count	= 2
		self.tackles_fail       = 2
		self.tackles_successful = 2
		self.passes_fail        = 2
		self.passess_successful = 2
		self.shots_on_target    = 2
		self.shots_off_target  	= 2
		self.shots_saved       	= 2
		self.penalty_scored    	= 2
		self.penalty_missed    	= 2
		self.penalty_saved     	= 2
		self.dribbles_lost     	= 2
		self.who_scored_rating 	= 2
	when 'MF'
	 	self.mins_played		= 3
		self.goals_scored		= 3
		self.goals_allowed		= 3
		self.goal_assists      	= 3
		self.own_goals         	= 3
		self.red_card_count    	= 3
		self.yellow_card_count	= 3
		self.tackles_fail       = 3
		self.tackles_successful	= 3
		self.passes_fail       	= 3
		self.passess_successful	= 3
		self.shots_on_target   	= 3
		self.shots_off_target  	= 3
		self.shots_saved       	= 3
		self.penalty_scored    	= 3
		self.penalty_missed    	= 3
		self.penalty_saved     	= 3
		self.dribbles_lost     	= 3
		self.who_scored_rating 	= 3
	when 'DF'
	 	self.mins_played		= 4
		self.goals_scored		= 4
		self.goals_allowed		= 4
		self.goal_assists      	= 4
		self.own_goals         	= 4
		self.red_card_count    	= 4
		self.yellow_card_count	= 4
		self.tackles_fail      	= 4
		self.tackles_successful = 4
		self.passes_fail       	= 4
		self.passess_successful	= 4
		self.shots_on_target   	= 4
		self.shots_off_target  	= 4
		self.shots_saved       	= 4
		self.penalty_scored    	= 4
		self.penalty_missed    	= 4
		self.penalty_saved     	= 4
		self.dribbles_lost     	= 4
		self.who_scored_rating  = 4
	when 'FW'
	 	self.mins_played		= 5
		self.goals_scored		= 5
		self.goals_allowed		= 5
		self.goal_assists      	= 5
		self.own_goals         	= 5
		self.red_card_count    	= 5
		self.yellow_card_count	= 5
		self.tackles_fail      	= 5
		self.tackles_successful	= 5
		self.passes_fail       	= 5
		self.passess_successful = 5
		self.shots_on_target   	= 5
		self.shots_off_target  	= 5
		self.shots_saved       	= 5
		self.penalty_scored    	= 5
		self.penalty_missed    	= 5
		self.penalty_saved     	= 5
		self.dribbles_lost     	= 5
		self.who_scored_rating 	= 5
	end
  end

end
