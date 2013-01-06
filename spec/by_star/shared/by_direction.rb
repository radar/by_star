require 'spec_helper'

shared_examples_for "by direction" do
  describe "before" do
    def posts_count(*args)
      Post.before(*args).count
    end

    it "should show the correct number of posts in the past" do
      posts_count.should == 5
    end

    it "is aliased as before_now" do
      Post.before_now.count.should == 5
    end

    it "should find for a given time" do
      posts_count(Time.zone.now - 2.days).should eql(2)
    end

    it "should find for a given date" do
      posts_count(Date.today - 2).should eql(2)
    end

    it "should find for a given string" do
      posts_count("next tuesday").should eql(8)
    end

    it "raises an exception when Chronic can't parse" do
      lambda { posts_count(";aosdjbjisdabdgofbi") }.should raise_error(ByStar::ParseError)
    end

    it "should be able to find all events before Ryan's birthday using a non-standard field" do
      Event.before(Time.local(Time.zone.now.year+2), :field => "start_time").count.should eql(8)
    end
  end

  describe "future" do
    def posts_count(*args)
      Post.after(*args).count
    end

    it "should show the correct number of posts in the future" do
      Post.after.count.should eql(posts_count)
      Post.after_now.count.should eql(posts_count)
    end

    it "should find for a given date" do
      posts_count(Date.today - 2).should eql(19)
    end

    it "should find for a given string" do
      posts_count("next tuesday").should eql(13)
    end

    it "should be able to find all events before Dad's birthday using a non-standard field" do
      Event.after(Time.zone.local(Time.zone.now.year, 7, 5), :field => "start_time").count.should eql(3)
    end
  end

  describe "previous and next" do
    let(:current_post)  { Post.find_by_text("post 1") }
    let(:current_event) { Event.find_by_name("Mum's birthday!") }

    context "previous" do
      it "can find the previous post" do
        current_post.previous.text.should == "Yesterday's post"
      end

      it "takes the field option" do
        current_event.previous(:field => "start_time").name.should == "Dad's birthday!"
      end
    end

    context "next" do
      it "can find the next post" do
        current_post.next.text.should == "Today's post"
      end

      it "takes the field option" do
        current_event.next(:field => "start_time").name.should == "Ryan's birthday!"
      end
    end
  end
end