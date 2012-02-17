require 'spec_helper'

describe "by_month" do
  def posts_count
    Post.by_month.count
  end

  it "should be able to find posts for the current month" do
    posts_count.should eql(10)
  end

  it "should be able to find a single post for January" do
    # If it is January we'll have all the "current" posts in there.
    # This makes the count 10.
    # I'm sure you can guess what happens when it's not January.
    posts_count("January").should eql(Time.now.month == 1 ? 10 : 1)
  end

  it "should be able to find two posts for the 2nd month" do
    # If it is February we'll have all the "current" posts in there.
    # This makes the count 10.
    # I'm sure you can guess what happens when it's not February.
    size(2).should eql(Time.now.month == 2 ? 10 : 1)
  end

  it "should be able to find three posts for the 3rd month, using time instance" do
    # If it is March we'll have all the "current" posts in there.
    # This makes the count 10.
    # I'm sure you can guess what happens when it's not March.
    time = Time.local(Time.zone.now.year, 3, 1)
    size(time).should eql(Time.now.month == 3 ? 10 : 1)
  end

  it "should be able to find a single post from January last year" do
    size("January", :year => Time.zone.now.year - 1).should eql(1)
  end

  it "should fail when given incorrect months" do
    lambda { find(0) }.should raise_error(ByStar::ParseError)
    lambda { find(13) }.should raise_error(ByStar::ParseError)
    lambda { find("Ryan") }.should raise_error(ByStar::ParseError)
    lambda { find([1,2,3]) }.should raise_error(ByStar::ParseError)
  end

  it "should be able to take decimals" do
    size(1.5).should eql(1)
  end

  it "should be able to use an alternative field" do
    if Time.zone.now.month == 12
      Event.by_month(nil, :field => "start_time").size.should eql(4)
    else
      stub_time(1, 12)
      Event.by_month(nil, :field => "start_time").size.should eql(1)
    end
  end

  it "should be able to specify the year as a string" do
    size(1, :year => (Time.zone.now.year - 1).to_s).should eql(1)
  end

end
