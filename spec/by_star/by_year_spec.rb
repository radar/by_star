require 'spec_helper'

describe "by year" do
  it "should be able to find all the posts in the current year" do
    Post.by_year.count.should eql(22)
  end

  it "should be able to find if given a string" do
    size(Time.zone.now.year.to_s).should eql(this_years_posts)
  end

  it "should be able to find a single post from last year" do
    size(Time.zone.now.year-1).should eql(2)
  end

  it "knows what last year's posts were" do
    find(Time.zone.now.year-1).map(&:text).should eql(["Last year", "End of last year"])
  end

  it "should error when given an invalid year" do
    if RUBY_VERSION < "1.8.7"
      lambda { find(1901) }.should raise_error(ByStar::ParseError, "Invalid arguments detected, year may possibly be outside of valid range (1902-2039)")
      lambda { find(2039) }.should raise_error(ByStar::ParseError, "Invalid arguments detected, year may possibly be outside of valid range (1902-2039)")
    else
      find(1456).should be_empty
      find(1901).should be_empty
      find(2039).should be_empty
    end
  end

  it "should be able to use an alternative field (string)" do
    Event.by_year(nil, :field => "start_time").size.should eql(8)
  end

  it "should be able to use an alternative field (symbol)" do
    Event.by_year(nil, :field => :start_time).size.should eql(8)
  end

  it "should not have to specify the field when using by_star_field" do
    Event.by_year.size.should eql(8)
  end

  it "should be able to use an alternative field (symbol) with directional searching" do
    stub_time
    Event.past(nil, :field => :start_time).size.should eql(1)
  end

  it "should be able to order the result set" do
    find(Time.zone.now.year, :order => "created_at DESC").first.text.should eql("That's it!")
  end
end

