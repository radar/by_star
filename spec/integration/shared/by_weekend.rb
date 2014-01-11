require 'spec_helper'

shared_examples_for "by weekend" do
  describe "by weekend" do
    it "should be able to find the posts on the weekend of the 1st of January" do
      Post.by_weekend.count.should eql(6)
    end

    it "should be able to use an alternative field" do
      Event.by_weekend(:field => "start_time").count.should eql(3)
    end
  end
end
