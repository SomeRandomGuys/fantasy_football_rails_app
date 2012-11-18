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

	it "should create a fantasy_league" do 
		fantasy_league = FactoryGirl.create(:fantasy_league)
		fantasy_league.should be_instance_of(FantasyLeague)
	end

	it "should create a fantasy_team" do
		fantasy_team = FactoryGirl.create(:fantasy_team)
		fantasy_team.should be_instance_of(FantasyTeam)
	end

	it "Should create a score multiplier object" do
		multiplier = FactoryGirl.create(:fantasy_score_multipliers)
		multiplier.should be_instance_of(FantasyScoreMultipliers)
	end

	it "should create a match object" do 
		match = FactoryGirl.create(:match)
		match.should be_instance_of(Match)
	end

	it "should create a match_player_stats object" do
		stats = FactoryGirl.create(:match_player_stats)
		stats.should be_instance_of(MatchPlayerStats)
	end

	it "should create a FANTASY MANAGER" do
		man = FactoryGirl.build(:fantasy_managers)
		puts ">>>>>>man.fantasy_league_id = #{man.fantasy_league_id}, #{man.name}"
		puts ">>>>>>>FantasyLeague.id = #{FantasyLeague.first.id}, #{FantasyLeague.first.name}"
	end
end

describe 'validate FactoryGirl factories' do
  FactoryGirl.factories.each do |factory|
    context "with factory for :#{factory.name}" do
      subject { FactoryGirl.build(factory.name) }

      it "is valid" do
        subject.valid?.should be, subject.errors.full_messages
      end
    end
  end
end

describe FantasyWeeklyScores do
	it "should correctly calculate the score" do
		
		FactoryGirl.create(:fantasy_weekly_scores)
		# FantasyWeeklyScores.update_weekly_scores
		# FantasyWeeklyScores.last.total_score.should eq(72)

		# puts ">>>>Total score: #{FantasyWeeklyScores.first.player_id}"
		# puts ">>>>Current game week: #{Player.first.id}"
	end
end