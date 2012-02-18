require 'spec_helper'

describe "by_month" do
  def find_posts(time=Time.zone.now, options={})
    Post.by_month(time, options)
  end

  def posts_count(time=Time.zone.now, options={})
    find_posts(time, options).count
  end

  it "should be able to find posts for the current month" do
    posts_count.should eql(8)
  end

  it "should be able to find a single post for January" do
    # If it is January we'll have all the "current" posts in there.
    # This makes the count 10.
    # I'm sure you can guess what happens when it's not January.
    posts_count("January").should eql(8)
  end

  it "should be able to find two posts for the 2nd month" do
    # If it is February we'll have all the "current" posts in there.
    # This makes the count 10.
    # I'm sure you can guess what happens when it's not February.
    posts_count(2).should eql(1)
  end

  it "should be able to find three posts for the 3rd month, using time instance" do
    # If it is March we'll have all the "current" posts in there.
    # This makes the count 10.
    # I'm sure you can guess what happens when it's not March.
    time = Time.local(Time.zone.now.year, 3, 1)
    posts_count(time).should eql(1)
  end

  it "should be able to find a single post from January last year" do
    posts_count("January", :year => Time.zone.now.year - 1).should eql(1)
  end

  it "should fail when given incorrect months" do
    lambda { find_posts(0) }.should raise_error(ByStar::ParseError)
    lambda { find_posts(13) }.should raise_error(ByStar::ParseError)
    lambda { find_posts("Ryan") }.should raise_error(ByStar::ParseError)
    # LOL arrays
    lambda { find_posts([1,2,3]) }.should raise_error(NoMethodError)
  end

  it "should be able to use an alternative field" do
    if Time.zone.now.month == 12
      Event.by_month(nil, :field => "start_time").size.should eql(4)
    else
      Timecop.freeze(Time.local(Time.now.year, 12, 1)) do
        Event.by_month(nil, :field => "start_time").size.should eql(1)
      end
    end
  end

  it "should be able to specify the year as a string" do
    posts_count(1, :year => (Time.zone.now.year - 1).to_s).should eql(1)
  end

end
