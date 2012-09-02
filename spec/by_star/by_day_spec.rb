require 'spec_helper'

describe "by day" do
  def posts_count(*args)
    Post.by_day(*args).count
  end

  it "should be able to find a post for today" do
    posts_count.should eql(4)
  end

  it "should be able to find a post by a given date in last year" do
    posts_count(:year => Time.zone.now.year - 1).should eql(1)
  end

  it "should be able to use an alternative field" do
    Event.by_day(Time.now.yesterday, :field => "start_time").size.should eql(1)
  end

  it "should be able to use a date" do
    posts_count(Date.today).should eql(4)
  end

  it "should be able to use a String" do
    posts_count(Date.today.to_s).should eql(4)
  end
end

describe "today" do
  it "should show the post for today" do
    Post.today.map(&:text).should include("Today's post")
  end

  it "should be able to use an alternative field" do
    # Test may occur on an event day.
    Event.today(:field => "start_time").size.should eql(1)
  end
end

describe "yesterday" do

  it "should show the post for yesterday" do
    Post.yesterday.map(&:text).should include("Yesterday's post")
  end

  it "should be able to use an alternative field" do
    Event.yesterday(:field => "start_time").size.should eql(1)
  end

end

describe "tomorrow" do
  it "should show the post for tomorrow" do
    Post.tomorrow.map(&:text).should include("Tomorrow's post")
  end

  it "should be able to use an alternative field" do
    Event.tomorrow(:field => "start_time").size.should eql(1)
  end
end
