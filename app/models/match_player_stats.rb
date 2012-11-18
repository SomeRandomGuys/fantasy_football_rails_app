# == Schema Information
#
# Table name: match_player_stats
#
#  id                 :integer          not null, primary key
#  match_id           :integer
#  player_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  mins_played        :integer
#  goals_scored       :integer
#  goals_allowed      :integer
#  goal_assists       :integer
#  own_goals          :integer
#  red_card_count     :integer
#  yellow_card_count  :integer
#  tackles_fail       :integer
#  tackles_successful :integer
#  passes_fail        :integer
#  passess_successful :integer
#  shots_on_target    :integer
#  shots_off_target   :integer
#  shots_saved        :integer
#  penalty_scored     :integer
#  penalty_missed     :integer
#  penalty_saved      :integer
#  dribbles_lost      :integer
#  who_scored_rating  :decimal(, )
#

class MatchPlayerStats < ActiveRecord::Base
	# validates :shots, :presence => true

	has_many :matches
	has_many :players
	before_save :set_defaults

	def self.weekly_player_stats(player_id, gameweek = GameWeeks.current_gameweek)
		matche_ids = Match.select(:id).matches_in_current_gameweek
		where(:player_id => player_id, :match_id => match_ids).first
	end

	def set_defaults

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

end
