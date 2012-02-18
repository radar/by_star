require 'spec_helper'

describe "by_year" do
  def posts_count(*args)
    find_posts(*args).count
  end

  def find_posts(*args)
    options = args.extract_options!
    Post.by_year(args.first, options)
  end

  let(:this_years_posts) { 20 }

  it "should be able to find all the posts in the current year" do
    posts_count.should eql(this_years_posts)
  end

  it "should be able to find if given a string" do
    posts_count(Time.zone.now.year.to_s).should eql(this_years_posts)
  end

  it "should be able to find a single post from last year" do
    posts_count(Time.zone.now.year-1).should eql(4)
  end

  it "knows what last year's posts were" do
    find_posts(Time.zone.now.year-1).map(&:text).should =~ ["Last year", "End of last year", "Yesterday", "Yesterday's post"]
  end

  it "should be able to use an alternative field (string)" do
    Event.by_year(:field => "start_time").count.should eql(7)
  end

  it "should be able to use an alternative field (symbol)" do
    Event.by_year(:field => :start_time).count.should eql(7)
  end

  it "should not have to specify the field when using by_star_field" do
    Event.by_year.count.should eql(7)
  end

  it "should not include yesterday's (Dec 31st <last year>) event in by_year" do
    Event.by_year.map(&:name).should_not include("Yesterday")
  end

  it "should be able to order the result set" do
    scope = find_posts(Time.zone.now.year, :order => "created_at DESC")
    scope.order_values.should == ["created_at DESC"]
  end
end

