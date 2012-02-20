require 'spec_helper'
describe "by week" do
  def posts_count(*args)
    find_posts(*args).count
  end

  def find_posts(*args)
    Post.by_week(*args)
  end

  it "should be able to find posts in the current week" do
    posts_count.should eql(5)
  end

  it "should be able to find posts in the 1st week" do
    posts_count(0).should eql(6)
  end

  it "should be able to find posts in the 1st week of last year" do
    posts_count(0, :year => Time.zone.now.year-1).should eql(1)
  end

  it "should not find any posts from a week ago" do
    posts_count(1.week.ago).should eql(1)
  end

  it "should be able to use an alternative field" do
    Event.by_week(:field => "start_time").size.should eql(2)
  end

  it "should find posts at the start of the year" do
    posts_count(0).should eql(6)
  end

  it "should find posts at the end of the year" do
    posts_count(Time.zone.now.end_of_year).should eql(1)
  end

end
