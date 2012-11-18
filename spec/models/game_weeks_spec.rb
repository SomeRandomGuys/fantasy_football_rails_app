# == Schema Information
#
# Table name: game_weeks
#
#  id                 :integer          not null, primary key
#  game_week_deadline :datetime
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe "GameWeeks" do
  before do
    dates = [ Date.today-13, Date.today-6, Date.today+1, Date.today+8, Date.today+15]
    dates.each do |date|
      GameWeeks.create(:game_week_deadline => date)
    end
  end

  it "should be instance of GameWeek" do
    GameWeeks.new.should be_an_instance_of(GameWeeks)
  end
  
  it "should have 5 records" do
    GameWeeks.all.count.should equal(5)
  end
  
  it "should return the correct game week" do
    GameWeeks.current_gameweek.game_week_deadline.to_date.should eq(Date.today-6)
  end
  
  it "should return the correct next game week" do
    GameWeeks.next_gameweek.game_week_deadline.to_date.should eq(Date.today+1)
  end
end

describe "Factroy Girl" do
  it "should create a game week" do
    game_week = FactoryGirl.create(:GameWeeks)
    game_week.game_week_deadline.to_date.should eq(Date.today-6)
  end
end
