require 'spec_helper'
Dir[File.dirname(__FILE__) + '/../shared/*.rb'].each {|file| require file }

describe 'Mongoid' do

  before(:all) do
    DATABASE_NAME = "mongoid_#{Process.pid}"
    # Moped.logger = Logger.new(STDOUT)

    Mongoid.configure do |config|
      config.connect_to DATABASE_NAME
    end

    load File.dirname(__FILE__) + '/../../fixtures/mongoid/models.rb'
    load File.dirname(__FILE__) + '/../../fixtures/shared/seeds.rb'
  end

  after(:all) do
    Mongoid.purge!
  end

  it_behaves_like 'between_times'
  it_behaves_like 'between_dates'
  it_behaves_like 'at_time'
  it_behaves_like 'offset parameter'
  it_behaves_like 'index_scope parameter'
  it_behaves_like 'by day'
  it_behaves_like 'by direction'
  it_behaves_like 'by fortnight'
  it_behaves_like 'by month'
  it_behaves_like 'by calendar month'
  it_behaves_like 'by quarter'
  it_behaves_like 'by week'
  it_behaves_like 'by cweek'
  it_behaves_like 'by weekend'
  it_behaves_like 'by year'
  it_behaves_like 'relative'
end if testing_mongoid?
