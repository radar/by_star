require 'spec/spec_helper'
require 'frozenplague/by_star'
include Frozenplague::ByStar

# Used in a couple of tests, sometimes changes when we add new data.
TOTAL_POSTS = 82
describe Post do
  
  
  it "should find all posts" do
    Post.count.should eql(TOTAL_POSTS)
  end
  
  
  describe "by year" do
    it "should be able to find all the posts in the current year" do
      Post.by_year.size.should eql(TOTAL_POSTS - 1)
    end
    
    it "should be able to find a single post from last year" do
      Post.by_year(Time.zone.now.year-1).size.should eql(1)
    end
  end
  
  describe "by month" do
    it "should be able to find a post for the current month" do
      Post.by_month.size.should eql(Time.zone.now.month+3)
    end
  
    it "should be able to find a single post for January" do
      Post.by_month("January").size.should eql(1)
    end
  
    it "should be able to find two posts for the 2nd month" do
      Post.by_month(2).size.should eql(2)
    end
  
    it "should be able to find three posts for the 3rd month, using time instance" do
      # Hack... if we're running this test during march there's going to be more posts than usual.
      # This is due to the #today, #yesterday and #tomorrow methods.
      
      Post.by_month(Time.local(Time.zone.now.year, 3, 1)).size.should eql(3)
    end
  
    it "should be able to find a single post from January last year" do
      Post.by_month("January", :year => Time.zone.now.year - 1).size.should eql(1)
    end
    
    it "should fail when given incorrect months" do
      lambda { Post.by_month(0) }.should raise_error(Frozenplague::ByStar::ParseError)
      lambda { Post.by_month(13) }.should raise_error(Frozenplague::ByStar::ParseError)
      lambda { Post.by_month("Ryan") }.should raise_error(Frozenplague::ByStar::ParseError)
      lambda { Post.by_month([1,2,3])}.should raise_error(Frozenplague::ByStar::ParseError)
    end
    
  end
  
  describe "by fortnight" do
    it "should be able to find posts in the 1st fortnight" do
      Post.by_fortnight(1).size.should eql(1)
    end
    
    it "should be able to find posts for a fortnight ago" do
      Time.stub!(:now).and_return("15-05-2009".to_time)
      Post.by_fortnight(2.weeks.ago).size.should eql(5)
    end
  end
  
  describe "by week" do
    it "should be able to find posts in the 1st week" do
      Post.by_week(1).size.should eql(1)
    end
    
    it "should be able to find posts in the 1st week of last year" do
      Post.by_week(1, :year => Time.zone.now.year-1).size.should eql(1)
    end
    
    it "should be able to find posts in the current week" do  
      Time.stub!(:now).and_return("15-05-2009".to_time)
      Post.by_week(1.week.ago).size.should eql(5)
    end
    
    it "should be able to find posts by a given date" do
      Time.stub!(:now).and_return("15-05-2009".to_time)
      Post.by_week(1.week.ago.to_date).size.should eql(5)
    end
  end
  
  describe "by day" do
    it "should be able to find a post for today" do
      Post.by_day.size.should eql(1)
    end
    
    it "should be able to find a post by a given date" do
      Post.by_day(Date.today).size.should eql(1)
    end
  end

  describe "today" do
    it "should show the post for today" do
      Post.today.map(&:text).should include("Today's post")
    end
  end
  
  describe "today, in another timezone" do
    before do
      Time.zone = "Brisbane"
    end
    
    it "should show the post for today" do
      Post.today.map(&:text).should include("Today's post")
    end
  end
  
  describe "yesterday" do
    it "should show the post for yesterday" do
      Post.yesterday.map(&:text).should include("Yesterday's post")
    end
    
    it "should be able find yesterday, given a Date" do
      Post.yesterday(Date.today-1).map(&:text).should include("Yesterday's post")
    end
  end
  
  describe "tomorrow" do
    it "should show the post for tomorrow" do
      Post.tomorrow.map(&:text).should include("Tomorrow's post")
    end
    
    it "should be able find tomorrow, given a Date" do
      Post.tomorrow(Date.today+1).map(&:text).should include("Tomorrow's post")
    end
  end
  
  describe "past" do
    it "should show the correct number of posts in the past" do
      Post.past.size.should eql(Post.count(:conditions => ["created_at < ?", Time.zone.now]))
    end
  end
  
  describe "future" do
    it "should show the correct number of posts in the future" do
      Post.future.size.should eql(Post.count(:conditions => ["created_at > ?", Time.zone.now]))
    end
  end
  
  describe "as of" do
    it "should be able to find posts as of 2 weeks ago" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("15-05-#{year}".to_time)
      Post.as_of_2_weeks_ago.size.should eql(5)
    end
    
    it "should not do anything if given an invalid date" do
      lambda { Post.as_of_ryans_birthday }.should raise_error(Frozenplague::ByStar::ParseError, "Chronic couldn't work out what you meant by 'Ryans birthday', please be more precise.")
    end
  end
  
  describe "up to" do
    it "should be able to find posts up to 2 weeks from now" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("15-05-#{year}".to_time)
      Post.up_to_6_weeks_from_now.size.should eql(9)
    end
    
    it "should not do anything if given an invalid date" do
      lambda { Post.up_to_ryans_birthday }.should raise_error(Frozenplague::ByStar::ParseError, "Chronic couldn't work out what you meant by 'Ryans birthday', please be more precise.")
    end
      
  end
  
  # Because we override method_missing, we ensure that it still works as it should with this test.
  describe "find_by_text" do
    it "should still work" do
      Post.find_by_text("Today's post").should_not be_nil
    end
  end
  
  
  describe "nested find" do
    it "should be able to find a single post from January last year with the tag 'ruby'" do
      Post.by_month("January", :year => Time.zone.now.year - 1) do
        { :include => :tags, :conditions => ["tags.name = ?", 'ruby'] }
      end.size.should eql(1)
    end
  end
  
end