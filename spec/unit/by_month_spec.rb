require 'spec/spec_helper'
require 'frozenplague/by_star'
include Frozenplague::ByStar
describe Post do
  
  
  it "should find all posts" do
    Post.count.should eql(80)
  end
  
  
  describe Post, "by year" do
    it "should be able to find all the posts in the current year" do
      Post.by_year.size.should eql(79)
    end
    
    it "should be able to find a single post from last year" do
      Post.by_year(Time.now.year-1).size.should eql(1)
    end
  end
  
  describe Post, "by month" do
    
    it "should be able to find a post for the current month" do
      Post.by_month.size.should eql(Time.now.month+1)
    end
  
    it "should be able to find a single post for January" do
      Post.by_month("January").size.should eql(1)
    end
  
    it "should be able to find two posts for the 2nd month" do
      Post.by_month(2).size.should eql(2)
    end
  
    it "should be able to find three posts for the 3rd month, using time instance" do
      # Hack... if we're running this test during march there's going to be one more post than usual.
      num = 4 if Time.now.month == 3
      num ||= 3
      
      Post.by_month(Time.local(Time.now.year, 3, 1)).size.should eql(num)
    end
  
    it "should be able to find a single post from January last year" do
      Post.by_month("January", :year => Time.now.year - 1).size.should eql(1)
    end
    
    it "should fail when given incorrect months" do
      lambda { Post.by_month(0) }.should raise_error(Frozenplague::ByStar::ParseError)
      lambda { Post.by_month(13) }.should raise_error(Frozenplague::ByStar::ParseError)
      lambda { Post.by_month("Ryan") }.should raise_error(Frozenplague::ByStar::ParseError)
      lambda { Post.by_month([1,2,3])}.should raise_error(Frozenplague::ByStar::ParseError)
    end
    
  end
  
  describe Post, "by fortnight" do
    it "should be able to find posts in the 1st fortnight" do
      Post.by_fortnight(1).size.should eql(1)
    end
  end
  
  describe Post, "by week" do
    it "should be able to find posts in the 1st week" do
      Post.by_week(1).size.should eql(1)
    end
    
    it "should be able to find posts in the 1st week of last year" do
      Post.by_week(1, :year => Time.now.year-1).size.should eql(1)
    end
  end
  
  describe Post, "by day" do
    it "should be able to find a post for today" do
      Post.by_day.size.should eql(1)
    end
  end
  
  describe Post, "today" do
    it "should show the post for today" do
      Post.today.first.text.should eql("Today's post")
    end
  end
  
  describe Post, "nested find" do
    it "should be able to find a single post from January last year with the tag 'ruby'" do
      Post.by_month("January", :year => Time.now.year - 1) do
        { :include => :tags, :conditions => ["tags.name = ?", 'ruby']}
      end.size.should eql(1)
    end
  end
end