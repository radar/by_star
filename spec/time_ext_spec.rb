require 'spec_helper'
describe Time do
  it "should work out the beginning of a weekend (Friday 3pm)" do
    Time.now.beginning_of_weekend.strftime("%A %I:%M%p").should eql("Friday 03:00PM")
  end

  it "should work out the end of a weekend (Monday 3am)" do
    Time.now.end_of_weekend.strftime("%A %I:%M%p").should eql("Monday 03:00AM")
  end
end
