require 'spec/spec_helper'

describe Post do
  
  it "should find all posts" do
    Post.count.should eql(79)
  end
  
  
  it "should be able to find a single post for January" do
    Post.by_month("January").size.should eql(1)
  end
  
  it "should be able to find two posts for the 2nd month" do
    Post.by_month(2).size.should eql(2)
  end
  
  it "should be able to find three posts for the 3rd month, using time instance" do
    Post.by_month(Time.local(Time.now.year, 3, 1)).size.should eql(3)
  end
  
  it "should be able to find a single post from January last year" do
    Post.by_month("January", :year => Time.now.year - 1).size.should eql(1)
  end
  
  it "should be able to find a single post from January last year with the tag 'ruby'" do
    Post.by_month("January", :year => Time.now.year - 1) do
      { :include => :tags, :conditions => ["tags.name = ?", 'ruby']}
    end.size.should eql(1)
  end
end