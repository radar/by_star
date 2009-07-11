require File.join(File.dirname(__FILE__), 'spec_helper')

describe User do
  before do
    @radar = User.find_by_login("radar")
    @you = User.find_by_login("you")
    @it = Thing.find_by_name("it")
    @sub = Thing.find_by_name("subby")
    @song = Thing.find_by_name("Can't Touch This")
  end
  
  describe "radar" do  
    it "should be able to touch this" do
      @radar.can?(:touch_this).should be_true
    end
    
    it "shouldn't be able to touch it" do
      @radar.can?(:touch_this, @it).should be_false
    end
  end
  
  describe "you" do
    it "can't touch this" do
      @you.can?(:touch_this).should be_true
    end
    
    it "can't touch subby" do
      @you.can?(:touch_this, @sub).should be_false
    end
    
    it "can touch the song" do
      @you.can?(:touch_this, @song).should be_true
    end
    
    it "really can't touch the song" do
      @you.really_can?(:touch_this, @song).should be_false
    end
  end  
  
  
end