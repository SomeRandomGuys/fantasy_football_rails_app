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

describe GameWeeks do
  before do
    dates = ['2012/8/18','2012/8/25','2012/9/1','2012/9/15','2012/9/22','2012/9/29','2012/10/6','2012/10/20','2012/10/27','2012/11/3']
    dates.each do |date|
      GameWeeks.create(:game_week_deadline => date)
    end
  end

  it "should be instance of GameWeek" do
    GameWeeks.new.should be_an_instance_of(GameWeeks)
  end
  
  it "should have 10 records" do
    GameWeeks.all.count.should equal(10)
  end
  
  it "should return the correct game week" do
    GameWeeks.current_gameweek.game_week_deadline.to_date.should eq(Date.new(2012,10,6))
  end
  
  it "should return the correct next game week" do
    GameWeeks.next_gameweek.game_week_deadline.to_date.should eq(Date.new(2012,10,20))
  end
end

describe "Factroy Girl" do
  it "should create a game week" do
    game_week = FactoryGirl.create(:game_weeks)
    game_week.game_week_deadline.to_date.should eq(Date.today)
  end
end
