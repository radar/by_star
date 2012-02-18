require 'spec_helper'
describe "by week" do
  def posts_count(*args)
    find_posts(*args).count
  end

  def find_posts(*args)
    Post.by_week(*args)
  end

  it "should be able to find posts in the current week" do
    posts_count.should eql(8)
  end

  it "should be able to find posts in the 1st week" do
    posts_count(0).should eql(1)
  end

  it "should be able to find posts in the 1st week of last year" do
    posts_count(0, :year => Time.zone.now.year-1).should eql(1)
  end

  it "should not find any posts from a week ago" do
    posts_count(1.week.ago).should eql(0)
  end

  it "should be able to find posts by a given date" do
    posts_count(1.week.ago.to_date).should eql(0)
  end

  it "should raise an error when given an invalid argument" do
    lambda { find(54) }.should raise_error(ByStar::ParseError, "by_week takes only a Time or Date object, a Fixnum (less than or equal to 53) or a Chronicable string.")
  end

  it "should be able to use an alternative field" do
    Event.by_week(nil, :field => "start_time").posts_count.should eql(0)
  end

  it "should find posts at the start of the year" do
    posts_count(0).should eql(1)
  end

  it "should find posts at the end of the year" do
    posts_count(Time.zone.now.end_of_year).should eql(1)
  end

end
