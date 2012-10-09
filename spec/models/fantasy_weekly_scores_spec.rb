# == Schema Information
#
# Table name: fantasy_weekly_scores
#
#  id              :integer          not null, primary key
#  fantasy_team_id :integer
#  player_id       :integer
#  game_week_id    :integer
#  total_score     :decimal(, )
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe "Factory Girl" do
  it "Should create a score multiplier object" do
    multiplier = FactoryGirl.create(:fantasy_score_multipliers)
    multiplier.should be_instance_of(FantasyScoreMultipliers)
  end
  
  it "should create a match_player_stats object" do
    stats = FactoryGirl.build(:match_player_stats)
    stats.should be_instance_of(MatchPlayerStats)
  end
end

describe FantasyWeeklyScores do
  it "should correctly calculate the score" do
        
  end
end