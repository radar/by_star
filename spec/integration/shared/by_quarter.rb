require 'spec_helper'

shared_examples_for "by quarter" do
  describe "by quarter" do
    def posts_count(*args)
      find_posts(*args).count
    end

    def find_posts(*args)
      Post.by_quarter(*args)
    end

    it "should be able to find posts in the current quarter" do
      posts_count.should eql(8)
    end

    it "should be able to find posts in the 1st quarter" do
      posts_count(1).should eql(8)
    end

    it "should be able to find posts in the 1st quarter of last year" do
      posts_count(1, :year => Time.zone.now.year-1).should eql(1)
    end

    it "should be able to use an alternative field" do
      Event.by_quarter(:field => "start_time").size.should eql(3)
    end

    it "should find posts at the last quarter of the year" do
      posts_count(Time.zone.now.end_of_year).should eql(4)
    end
  end
end
