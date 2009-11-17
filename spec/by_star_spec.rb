require File.join(File.dirname(__FILE__), 'spec_helper')
require 'by_star'

describe Post do
    
  def stub_time(day=15, month=5, year=Time.zone.now.year, hour=0, minute=0)
    stub = "#{day}-#{month}-#{year} #{hour}:#{minute}".to_time
    Time.stub!(:now).and_return(stub)
    Time.zone.stub!(:now).and_return(stub)
  end
  
  def range_test(&block)
    (1..31).to_a.each do |d|
      stub_time(d, 07, 2009, 05, 05)
      block.call
    end
  end
  
  def find(*args)
    method = description_args.first.sub(' ', '_')
    Post.send(method, *args)
  end
  
  def size(*args)
    method = description_args.first.sub(' ', '_')
    Post.send(method, *args).size
  end
  
  ["mysql", "sqlite3"].each do |adapter|
    ActiveRecord::Base.establish_connection(YAML::load_file(File.dirname(__FILE__) + "/database.yml")[adapter])
  
    describe "by year" do
      it "should be able to find all the posts in the current year" do
        size.should eql(Post.count - 1)
      end
    
      it "should be able to find if given a string" do
        size(Time.zone.now.year.to_s).should eql(Post.count - 1)
      end
    
      it "should be able to find a single post from last year" do
        size(Time.zone.now.year-1).should eql(1)
      end
    
      it "should error when given an invalid year" do
        # This is broken on 1.8.6 (and previous versions), any patchlevel after & before 111
        major, minor, trivial = RUBY_VERSION.split(".").map(&:to_i)
        if major == 1 && ((minor == 8 && trivial <= 6) || (minor <= 8)) && RUBY_PATCHLEVEL.to_i > 111
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
      
      it "should be able to use an alternative field (symbol) with directional searching" do
        stub_time
        Event.past(nil, :field => :start_time).size.should eql(1)
      end
      
      it "should be able to order the result set" do
        find(Time.zone.now.year, :order => "created_at DESC").first.text.should eql("That's it!")
      end
    end
  
    describe "by month" do
    
      it "should be able to find posts for the current month" do
        stub_time
        size.should eql(8)
      end
      
      it "should be able to find a single post for January" do
        size("January").should eql(1)
      end
  
      it "should be able to find two posts for the 2nd month" do
        size(2).should eql(2)
      end
  
      it "should be able to find three posts for the 3rd month, using time instance" do
        # Hack... if we're running this test during march there's going to be more posts than usual.
        # This is due to the #today, #yesterday and #tomorrow methods.
      
        size(Time.local(Time.zone.now.year, 3, 1)).should eql(3)
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
        stub_time(1, 12)
        Event.by_month(nil, :field => "start_time").size.should eql(1)
      end
    
      it "should be able to specify the year as a string" do
        size(1, :year => (Time.zone.now.year - 1).to_s).should eql(1)
      end
    
    end
  
    describe "by fortnight" do
    
      it "should be able to find posts in the current fortnight" do
        stub_time
        size.should eql(3)
      end
    
      it "should be able to find posts in the 1st fortnight" do
        size(0).should eql(1)
      end
    
      it "should be able to find posts for a fortnight ago" do
        stub_time
        size(2.weeks.ago).should eql(5)
      end
    
      it "should raise an error when given an invalid argument" do
        lambda { find(27) }.should raise_error(ByStar::ParseError, "by_fortnight takes only a Time or Date object, a Fixnum (less than or equal to 26) or a Chronicable string.")
      end
    
      it "should be able to use an alternative field" do
        stub_time
        Event.by_fortnight(nil, :field => "start_time").size.should eql(0)
      end
    end
  
    describe "by week" do
    
      it "should be able to find posts in the current week" do
        stub_time
        size.should eql(3)
      end
    
      it "should be able to find posts in the 1st week" do
        size(0).should eql(1)
      end
    
      it "should be able to find posts in the 1st week of last year" do
        size(0, :year => Time.zone.now.year-1).should eql(1)
      end
    
      it "should not find any posts from a week ago" do  
        stub_time
        size(1.week.ago).should eql(0)
      end
    
      it "should be able to find posts by a given date" do
        stub_time
        size(1.week.ago.to_date).should eql(0)
      end
    
      it "should find, not size the posts for the current week" do
        stub_time
        find.map(&:text).include?("The 'Current' Week")
        find.map(&:text).include?("Weekend of May")
      end
    
      it "should raise an error when given an invalid argument" do
        lambda { find(54) }.should raise_error(ByStar::ParseError, "by_week takes only a Time or Date object, a Fixnum (less than or equal to 53) or a Chronicable string.")
      end
    
      it "should be able to use an alternative field" do
        stub_time
        Event.by_week(nil, :field => "start_time").size.should eql(0)
      end
    
      it "should find posts at the start of the year" do
        size(0).should eql(1)
      end
    
      it "should find posts at the end of the year" do
        size(Time.zone.now.end_of_year).should eql(1)
      end
    
    end
  
    describe "by weekend" do
      it "should be able to find the posts on the weekend of the 1st May" do
        stub_time(1, 8)
        size.should eql(8)
      end
    
      it "should be able to use an alternative field" do
        year = Time.zone.now.year
        stub_time(1, 8)
        Event.by_weekend(nil, :field => "start_time").size.should eql(1)
      end
    end
  
    describe "by current weekend" do
      it "should work" do
        range_test do
          Post.by_current_weekend
        end
      end
    end
  
    describe "by current work week" do
      it "should work" do
        range_test do
          Post.by_current_work_week
        end
      end
    end
  
    describe "by day" do
      it "should be able to find a post for today" do
        stub_time
        size.should eql(2)
      end
    
      it "should be able to find a post by a given date" do
        stub_time
        size(Date.today).should eql(2)
      end
    
      it "should be able to use an alternative field" do
        Event.by_day(Time.now - 1.day, :field => "start_time").size.should eql(1)
      end
    end

    describe "today" do
      it "should show the post for today" do
        find.map(&:text).should include("Today's post")
      end
    
      it "should be able to use an alternative field" do
        # Test may occur on an event day.
        stub_time
        Event.today(nil, :field => "start_time").size.should eql(0)
      end
    
    end
  
    describe "tomorrow" do
      it "should show the post for tomorrow" do
        find.map(&:text).should include("Tomorrow's post")
      end
    end
    
    describe "yesterday" do
      it "should show the post for yesterday" do
        find.map(&:text).should include("Yesterday's post")
      end
    
      it "should be able find yesterday, given a Date" do
        find(Time.now).map(&:text).should include("Yesterday's post")
      end
    
      it "should be able to use an alternative field" do
        # Test may occur on an event day.
        stub_time
        Event.yesterday(nil, :field => "start_time").size.should eql(0)
      end
    
    end
  
    describe "tomorrow" do
      it "should show the post for tomorrow" do
        find.map(&:text).should include("Tomorrow's post")
      end
    
      it "should be able find tomorrow, given a Date" do
        find(Time.now).map(&:text).should include("Tomorrow's post")
      end
    
      it "should be able to use an alternative field" do
        # Test may occur on an event day.
        stub_time
        Event.tomorrow(nil, :field => "start_time").size.should eql(0)
      end
    end
  
    describe "past" do
    
      before do
        stub_time
      end
    
      it "should show the correct number of posts in the past" do
        size.should eql(16)
      end
    
      it "should find for a given time" do
        size(Time.zone.now - 2.days).should eql(16)
      end
    
      it "should find for a given date" do
        size(Date.today - 2).should eql(16)
      end
    
      it "should find for a given string" do
        size("next tuesday").should eql(19)
      end
    
      it "should be able to find all events before Ryan's birthday using a non-standard field" do
        Event.past("04-12-#{Time.zone.now.year}".to_time, :field => "start_time").size.should eql(7)
      end 
      
      it "should be able to order the find" do
        find(Date.today, :order => "created_at ASC").first.text.should eql("Last year")
        find(Date.today, :order => "created_at DESC").first.text.should eql("post 0")
      end
    
    end
  
    describe "future" do
      before do
        stub_time
      end
    
      it "should show the correct number of posts in the future" do
        size.should eql(71)
      end
    
      it "should find for a given date" do
        size(Date.today - 2).should eql(73)
      end
    
      it "should find for a given string" do
        size("next tuesday").should eql(70)
      end
    
      it "should be able to find all events after Dad's birthday using a non-standard field" do
        Event.past("05-07-#{Time.zone.now.year}".to_time, :field => "start_time").size.should eql(1)
      end
    end
  
    describe "as of" do
      it "should be able to find posts as of 2 weeks ago" do
        stub_time
        Post.as_of_2_weeks_ago.size.should eql(7)
      end
    
      it "should be able to find posts as of 2 weeks before a given time" do
        stub_time
        Post.as_of_2_weeks_ago(Time.zone.now + 1.month).size.should eql(14)
      end
    
      it "should error if given a date in the past far enough back" do
        lambda { Post.as_of_6_weeks_ago(Time.zone.now - 2.months) }.should raise_error(ByStar::ParseError, "End time is before start time, searching like this will return no results.")
      end
    
      it "should not do anything if given an invalid date" do
        lambda { Post.as_of_ryans_birthday }.should raise_error(ByStar::ParseError, "Chronic couldn't work out \"Ryans birthday\"; please be more precise.")
      end
    end
  
    describe "between" do
      it "should find posts between last tuesday and next tuesday" do
        stub_time
        size("last tuesday", "next tuesday").should eql(3)
      end
    
      it "should find between two times" do
        stub_time
        size(Time.zone.now - 5.days, Time.zone.now + 5.days).should eql(3)
      end
    
      it "should find between two dates" do
        stub_time
        size(Date.today, Date.today + 5).should eql(3)
      end
    end
  
    describe "up to" do
      it "should be able to find posts up to 2 weeks from now" do
        stub_time
        Post.up_to_6_weeks_from_now.size.should eql(9)
      end
    
      it "should be able to find posts up to 2 weeks from a given time" do
        stub_time
        Post.up_to_6_weeks_from_now(Time.zone.now - 1.month).size.should eql(14)
      end
    
      it "should error if given a date in the past" do
        lambda { Post.up_to_6_weeks_from_now(Time.zone.now + 2.months) }.should raise_error(ByStar::ParseError, "End time is before start time, searching like this will return no results.")
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
  
    describe "named_scopes" do
      it "should be compatible" do
        Event.private.by_year(nil, :field => "start_time").size.should eql(1)
      end
    end
  
    describe "joins" do
      it "should not have ambiguous column names" do
        lambda { Post.by_month do
          { :joins => :tags }
        end }.should_not raise_error
      end
    end
  
  
    describe "nested find" do
    
      it "should be able to find posts after right now" do
        stub_time
        Post.by_current_work_week.size.should eql(2)
        Post.by_current_work_week do
          { :conditions => ["created_at > ?", Time.now] }
        end.size.should eql(0)
      end
  
      it "should be able to find a single post from last year with the tag 'ruby'" do
        Post.by_year(Time.zone.now.year - 1) do
          { :include => :tags, :conditions => ["tags.name = ?", 'ruby'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from January last year with the tag 'ruby'" do
        Post.by_month("January", :year => Time.zone.now.year - 1) do
          { :include => :tags, :conditions => ["tags.name = ?", 'ruby'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from the current fortnight with the tag 'may2'" do
        stub_time
        Post.by_fortnight do
          { :include => :tags, :conditions => ["tags.name = ?", 'may2'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from the current week with the tag 'may2'" do
        stub_time
        Post.by_week do
          { :include => :tags, :conditions => ["tags.name = ?", 'may2'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from the current weekend with the tag 'weekend'" do
        stub_time
        Post.by_weekend do
          { :include => :tags, :conditions => ["tags.name = ?", 'weekend'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from the current day with the tag 'today'" do
        Post.by_day do
          { :include => :tags, :conditions => ["tags.name = ?", 'today'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from yesterday with the tag 'yesterday'" do
        Post.yesterday do
          { :include => :tags, :conditions => ["tags.name = ?", 'yesterday'] }
        end.size.should eql(1)
      end
    
    
      it "should be able to find a single post from tomorrow with the tag 'tomorrow'" do
        Post.tomorrow do
          { :include => :tags, :conditions => ["tags.name = ?", 'tomorrow'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from the past with the tag 'yesterday'" do
        Post.past do
          { :include => :tags, :conditions => ["tags.name = ?", 'yesterday'] }
        end.size.should eql(1)
      end
    
      it "should be able to find a single post from the future with the tag 'tomorrow'" do
        Post.future do
          { :include => :tags, :conditions => ["tags.name = ?", 'tomorrow'] }
        end.size.should eql(1)
      end
      
      it "should work when block is empty" do
        stub_time
        Post.future { }.size.should eql(71)
      end
      
      it "should be able to find a single post from the future with the tag 'tomorrow' (redux)" do
        Post.future(Time.zone.now, :include => :tags, :conditions => ["tags.name = ?", 'tomorrow']).size.should eql(1)
      end
    
    end
  
    describe "Calculations" do
      describe "Sum" do
        describe "by year" do
          it "current year" do
            stub_time
            Invoice.sum_by_year(:value).should eql(374000)
          end
        end
      
        describe "by month" do
          it "current month" do
            stub_time
            Invoice.sum_by_month(:value).should eql(15000)
          end
        end
      end
    
      describe "Count" do
        describe "by year" do
          it "current year" do
            Invoice.count_by_year.should eql(79)
          end
        
          it "using a field" do
            Invoice.count_by_year(:number).should eql(Invoice.by_year.size-1)
          end
        
          it "different year" do
            Invoice.count_by_year(:all, 2008)
          end
          
          it "current year with the given tag" do
            Post.count_by_year do
              { :include => :tags, :conditions => ["tags.name = ?", 'tomorrow'] }
            end.should eql(1)
          end
        end
      
        describe "by month" do
          it "current month" do
            Invoice.count_by_month
          end
        
          it "using a field" do
            Invoice.count_by_month(:number).should eql(Invoice.by_month.size-1)
          end
        
          it "different month" do
            stub_time
            Invoice.count_by_month(:all, 9)
          end
          
          it "current month with the given tag" do
            Post.count_by_month(:all, Time.zone.now) do
              { :include => :tags, :conditions => ["tags.name = ?", 'tomorrow'] }
            end.should eql(1)
          end
          
          it "current month with blank block" do
            stub_time
            Post.count_by_month(:all, Time.zone.now) { }.should eql(8)
          end
        end
      end

    end
    
    describe "edge cases" do
      # This method previously generated sql like: `day_entries`.`spent_at`.`spent_at`.`spent_at`.`spent_at`
      # Which is *obviously* incorrect and #omg worthy.
      it "should not spam the field name when using a different field" do
        Invoice.first.day_entries.between((Time.zone.now - 3.days).to_date, Time.zone.now.to_date, :field => "spent_at")
      end
    end
  
    describe Time do
      it "should work out the beginning of a weekend (Friday 3pm)" do
        range_test do 
          Time.now.beginning_of_weekend.strftime("%A %I:%M%p").should eql("Friday 03:00PM")
        end
      end
    
      it "should work out the end of a weekend (Monday 3am)" do
        range_test do
          Time.now.end_of_weekend.strftime("%A %I:%M%p").should eql("Monday 03:00AM")
        end
      end
    end
  end
  
end