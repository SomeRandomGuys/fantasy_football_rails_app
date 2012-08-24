# == Schema Information
#
# Table name: match_player_stats
#
#  id               :integer          not null, primary key
#  match_id         :integer
#  player_id        :integer
#  started          :boolean
#  goals            :integer
#  own_goals        :integer
#  assists          :integer
#  yellow_cards     :integer
#  red_cards        :integer
#  saves            :integer
#  playing_time     :integer
#  shots            :integer
#  shots_on_target  :integer
#  penalties_taken  :integer
#  penalties_scored :integer
#  penalties_saved  :integer
#  position_played  :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class MatchPlayerStats < ActiveRecord::Base
end
