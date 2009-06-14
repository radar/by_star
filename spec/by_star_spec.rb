require 'spec_helper'
require 'by_star'

# Used in a couple of tests, sometimes changes when we add new data.
TOTAL_POSTS = 82
describe Post do
  
  def stub_time
    year = Time.zone.now.year
    Time.stub!(:now).and_return("15-05-#{year}".to_time)
  end
  
  def find(*args)
    method = description_args.first.sub(' ', '_')
    Post.send(method, *args)
  end
  
  
  describe "by year" do
    it "should be able to find all the posts in the current year" do
      find.size.should eql(TOTAL_POSTS - 1)
    end
    
    it "should be able to find a single post from last year" do
      find(Time.zone.now.year-1).size.should eql(1)
    end
    
    it "should error when given an invalid year" do
      lambda { find(1901) }.should raise_error(ByStar::ParseError, "Invalid arguments detected, year may possibly be outside of valid range (1902-2039)")
      lambda { find(2039) }.should raise_error(ByStar::ParseError, "Invalid arguments detected, year may possibly be outside of valid range (1902-2039)")
    end
  end
  
  describe "by month" do
    it "should be able to find a post for the current month" do
      find.size.should eql(Time.zone.now.month+3)
    end
  
    it "should be able to find a single post for January" do
      find("January").size.should eql(1)
    end
  
    it "should be able to find two posts for the 2nd month" do
      find(2).size.should eql(2)
    end
  
    it "should be able to find three posts for the 3rd month, using time instance" do
      # Hack... if we're running this test during march there's going to be more posts than usual.
      # This is due to the #today, #yesterday and #tomorrow methods.
      
      find(Time.local(Time.zone.now.year, 3, 1)).size.should eql(3)
    end
  
    it "should be able to find a single post from January last year" do
      find("January", :year => Time.zone.now.year - 1).size.should eql(1)
    end
    
    it "should fail when given incorrect months" do
      lambda { find(0) }.should raise_error(ByStar::ParseError)
      lambda { find(13) }.should raise_error(ByStar::ParseError)
      lambda { find("Ryan") }.should raise_error(ByStar::ParseError)
      lambda { find([1,2,3])}.should raise_error(ByStar::ParseError)
    end
    
  end
  
  describe "by fortnight" do
    
    it "should be able to find posts in the current fortnight" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("1-08-#{year}".to_time)
      find.size.should eql(8)
    end
    
    it "should be able to find posts in the 1st fortnight" do
      find(1).size.should eql(1)
    end
    
    it "should be able to find posts for a fortnight ago" do
      stub_time
      find(2.weeks.ago).size.should eql(5)
    end
    
    it "should raise an error when given an invalid argument" do
      lambda { find(27) }.should raise_error(ByStar::ParseError, "by_fortnight takes only a Time or Date object, or a Fixnum (less than or equal to 26).")
    end
  end
  
  describe "by week" do
    
    it "should be able to find posts in the current week" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("15-05-#{year}".to_time)
      find.size.should eql(0)
    end
    
    it "should be able to find posts in the 1st week" do
      find(1).size.should eql(1)
    end
    
    it "should be able to find posts in the 1st week of last year" do
      find(1, :year => Time.zone.now.year-1).size.should eql(1)
    end
    
    it "should be able to find posts in the current week" do  
      stub_time
      find(1.week.ago).size.should eql(5)
    end
    
    it "should be able to find posts by a given date" do
      stub_time
      find(1.week.ago.to_date).size.should eql(5)
    end
    
    it "should raise an error when given an invalid argument" do
      lambda { find(54) }.should raise_error(ByStar::ParseError, "by_week takes only a Time or Date object, or a Fixnum (less than or equal to 53).")
    end
  end
  
  describe "by weekend" do
    it "should be able to find the posts on the weekend of the 1st May" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("1-08-#{year}".to_time)
      find.size.should eql(8)
    end
  end
  
  describe "by day" do
    it "should be able to find a post for today" do
      find.size.should eql(1)
    end
    
    it "should be able to find a post by a given date" do
      find(Date.today).size.should eql(1)
    end
  end

  describe "today" do
    it "should show the post for today" do
      find.map(&:text).should include("Today's post")
    end
  end
  
  describe "yesterday" do
    it "should show the post for yesterday" do
      find.map(&:text).should include("Yesterday's post")
    end
    
    it "should be able find yesterday, given a Date" do
      find(Date.today).map(&:text).should include("Yesterday's post")
    end
  end
  
  describe "tomorrow" do
    it "should show the post for tomorrow" do
      find.map(&:text).should include("Tomorrow's post")
    end
    
    it "should be able find tomorrow, given a Date" do
      find(Date.today).map(&:text).should include("Tomorrow's post")
    end
  end
  
  describe "past" do
    it "should show the correct number of posts in the past" do
      find.size.should eql(Post.count(:conditions => ["created_at < ?", Time.zone.now]))
    end
  end
  
  describe "future" do
    it "should show the correct number of posts in the future" do
      find.size.should eql(Post.count(:conditions => ["created_at > ?", Time.zone.now]))
    end
  end
  
  describe "as of" do
    it "should be able to find posts as of 2 weeks ago" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("15-05-#{year}".to_time)
      Post.as_of_2_weeks_ago.size.should eql(5)
    end
    
    it "should not do anything if given an invalid date" do
      lambda { Post.as_of_ryans_birthday }.should raise_error(ByStar::ParseError, "Chronic couldn't work out \"Ryans birthday\"; please be more precise.")
    end
  end
  
  describe "up to" do
    it "should be able to find posts up to 2 weeks from now" do
      year = Time.zone.now.year
      Time.stub!(:now).and_return("15-05-#{year}".to_time)
      Post.up_to_6_weeks_from_now.size.should eql(9)
    end
    
    it "should not do anything if given an invalid date" do
      lambda { Post.up_to_ryans_birthday }.should raise_error(ByStar::ParseError, "Chronic couldn't work out \"Ryans birthday\"; please be more precise.")
    end
      
  end
  
  # Because we override method_missing, we ensure that it still works as it should with this test.
  describe "method_missing" do
    it "should still work" do
      Post.find_by_text("Today's post").should_not be_nil
    end
    
    it "should raise a proper NoMethodError" do
      lambda { Post.idontexist }.should raise_error(NoMethodError, %r(^undefined method `idontexist'))
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