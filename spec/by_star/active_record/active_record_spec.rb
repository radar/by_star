require 'active_record'
require 'spec_helper'
Dir[File.dirname(__FILE__) + '/../generic/*.rb'].each {|file| require file }

describe "active record" do
  before(:all) do
    ActiveRecord::Base.default_timezone = :utc

    db_config = YAML::load_file(File.dirname(__FILE__) + "/../../database.yml")
    if db_config.has_key?('sqlite') && db_config['sqlite'].has_key?('database')
      db_config['sqlite']['database'] = File.dirname(__FILE__) + '/../../tmp/' + db_config['sqlite']['database']
    end

    ActiveRecord::Base.configurations = db_config
    ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite")
    load File.dirname(__FILE__) + "/../../fixtures/active_record/schema.rb"
    load File.dirname(__FILE__) + "/../../fixtures/active_record/models.rb"
    load File.dirname(__FILE__) + "/../../fixtures/generic/seeds.rb"

    ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../../tmp/activerecord.log")
  end

  it_behaves_like "by day"
  it_behaves_like "by direction"
  it_behaves_like "by fortnight"
  it_behaves_like "by month"
  it_behaves_like "by week"
  it_behaves_like "by weekend"
  it_behaves_like "by year"
end