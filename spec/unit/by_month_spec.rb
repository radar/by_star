require 'spec/spec_helper'

describe Post do
  it "should be able to find a single post for January" do
    Post.by_month("January").size.should eql(1)
  end
  
  it "should be able to find two posts for the 2nd month" do
    Post.by_month(2).size.should eql(2)
  end
  
  it "should be able to find three posts for the 3rd month, using time instance" do
    Post.by_month(Time.local(2008, 3, 1)).size.should eql(3)
  end
end