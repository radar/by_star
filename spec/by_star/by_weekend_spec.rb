require 'spec_helper'

describe 'by weekend' do

  it "should be able to find the posts on the weekend of the 1st of January" do
    p Post.by_weekend.to_sql
    posts_count = Post.by_weekend.count
    posts_count.should eql(8)
  end

  it "should be able to use an alternative field" do
    Event.by_weekend(:field => "start_time").count.should eql(2)
  end
end
