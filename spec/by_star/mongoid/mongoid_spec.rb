require 'mongoid'
require 'spec_helper'
Dir[File.dirname(__FILE__) + '/../generic/*.rb'].each {|file| require file }

describe "mongoid" do
  before(:all) do
    DATABASE_NAME = "mongoid_#{Process.pid}"

    Mongoid.configure do |config|
      config.connect_to DATABASE_NAME
    end

    load File.dirname(__FILE__) + "/../../fixtures/mongoid/models.rb"
    load File.dirname(__FILE__) + "/../../fixtures/generic/seeds.rb"
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
end