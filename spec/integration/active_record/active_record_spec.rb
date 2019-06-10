require 'spec_helper'
Dir[File.dirname(__FILE__) + '/../shared/*.rb'].each {|file| require file }

describe ActiveRecord do
  before(:all) do
    ActiveRecord::Base.default_timezone = :utc
    # ActiveRecord::Base.logger = Logger.new(STDOUT)

    db_config = YAML::load_file(File.dirname(__FILE__) + '/../../database.yml')
    if db_config.has_key?('sqlite') && db_config['sqlite'].has_key?('database')
      db_config['sqlite']['database'] = File.dirname(__FILE__) + '/../../tmp/' + db_config['sqlite']['database']
    end

    ActiveRecord::Base.configurations = db_config
    ActiveRecord::Base.establish_connection(ENV['DB'].try(:to_sym) || :sqlite)
    load File.dirname(__FILE__) + '/../../fixtures/active_record/schema.rb'
    load File.dirname(__FILE__) + '/../../fixtures/active_record/models.rb'
    load File.dirname(__FILE__) + '/../../fixtures/shared/seeds.rb'

    ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/../../tmp/activerecord.log')
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
end if testing_active_record?
