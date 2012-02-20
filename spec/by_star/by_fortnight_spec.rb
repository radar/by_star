require 'spec_helper'

describe "by fortnight" do

  def find_posts(*args)
    Post.by_fortnight(*args)
  end

  def posts_count(*args)
    find_posts(*args).count
  end

  it "should be able to find posts in the current fortnight" do
    posts_count.should eql(6)
  end

  it "should be able to find posts in the 1st fortnight of the current year" do
    posts_count(0).should eql(6)
    posts_count("0").should eql(6)
    # There was previously a situation where incorrect time zone math
    # caused the 'post 1' post to NOT appear, so count would be 7, rather than 8.
    # So this line simply regression tests that problem.
    Post.by_fortnight(0).map(&:text).should include("post 1")
  end

  it "should be able to find posts for a fortnight ago" do
    posts_count(2.weeks.ago).should eql(2)
  end

  it "should be able to find posts for a given fortnight in a year" do
    posts_count(0, :year => Time.zone.now.year - 1).should eql(1)
  end

  it "should be able to find posts for the current fortnight in a specific year" do
    posts_count(:year => Time.zone.now.year - 1).should eql(1)
  end

  it "should raise an error when given an invalid argument" do
    lambda { find_posts(27) }.should raise_error(ByStar::ParseError, "by_fortnight takes only a Time, Date or a Fixnum (less than or equal to 26).")
  end

  it "should be able to use an alternative field" do
    Event.by_fortnight(nil, :field => "start_time").count.should eql(2)
  end
end

