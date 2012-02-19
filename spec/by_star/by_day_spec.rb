require 'spec_helper'

describe "by day" do
  def posts_count(*args)
    Post.by_day(*args).count
  end

  it "should be able to find a post for today" do
    posts_count.should eql(5)
  end

  it "should be able to find a post by a given date" do
    posts_count(Date.today).should eql(5)
  end

  it "should be able to find a post by a given date in last year" do
    posts_count(:year => Time.zone.now.year - 1).should eql(1)
  end

  it "should be able to use an alternative field" do
    Event.by_day(Time.now.yesterday, :field => "start_time").size.should eql(1)
  end
end
