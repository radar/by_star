require 'spec_helper'
Dir[File.dirname(__FILE__) + '/../shared/*.rb'].each {|file| require file }

describe 'mongoid', :if => Gem::Version.create(RUBY_VERSION.dup) >= Gem::Version.create('1.9.3') do

  before(:all) do
    DATABASE_NAME = "mongoid_#{Process.pid}"

    Mongoid.configure do |config|
      config.connect_to DATABASE_NAME
    end

    load File.dirname(__FILE__) + "/../../fixtures/mongoid/models.rb"
    load File.dirname(__FILE__) + "/../../fixtures/shared/seeds.rb"
  end

  after(:all) do
    Mongoid.purge!
  end

  it_behaves_like "by day"
  it_behaves_like "by direction"
  it_behaves_like "by fortnight"
  it_behaves_like "by month"
  it_behaves_like "by week"
  it_behaves_like "by weekend"
  it_behaves_like "by year"

  describe "#between" do
    it "should return a Mongoid::Critera object" do
      Post.between(Date.today - 2, Date.today).class.should == Mongoid::Criteria
    end
    it "should return a result set between two times" do
      Post.between(Date.today - 2, Date.today).count.should == 1
    end
  end

  describe "#between_times" do
    it "should be an alias of #between" do
      Post.between_times(Date.today - 2, Date.today).should == Post.between(Date.today - 2, Date.today)
    end
  end
end