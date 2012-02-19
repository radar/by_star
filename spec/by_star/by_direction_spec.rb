require 'spec_helper'
describe "before" do
  def posts_count(*args)
    Post.before(*args).count
  end

  it "should show the correct number of posts in the past" do
    posts_count.should == 9
  end

  it "is aliased as before_now" do
    Post.before_now.count.should == 9
  end

  it "should find for a given time" do
    posts_count(Time.zone.now - 2.days).should eql(1)
  end

  it "should find for a given date" do
    posts_count(Date.today - 2).should eql(1)
  end

  it "should find for a given string" do
    posts_count("next tuesday").should eql(11)
  end

  it "raises an exception when Chronic can't parse" do
    lambda { posts_count(";aosdjbjisdabdgofbi") }.should raise_error(ByStar::ParseError)
  end

  it "should be able to find all events before Ryan's birthday using a non-standard field" do
    Event.before(Time.local(Time.zone.now.year+2), :field => "start_time").count.should eql(9)
  end
end

describe "future" do
  def posts_count(*args)
    Post.after(*args).count
  end

  it "should show the correct number of posts in the future" do
    Post.after.count.should eql(15)
    Post.after_now.count.should eql(15)
  end

  it "should find for a given date" do
    posts_count(Date.today - 2).should eql(23)
  end

  it "should find for a given string" do
    posts_count("next tuesday").should eql(13)
  end

  it "should be able to find all events before Dad's birthday using a non-standard field" do
    Event.after(Time.zone.local(Time.zone.now.year, 7, 5), :field => "start_time").count.should eql(4)
  end
end
