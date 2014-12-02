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
    ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite')
    load File.dirname(__FILE__) + '/../../fixtures/active_record/schema.rb'
    load File.dirname(__FILE__) + '/../../fixtures/active_record/models.rb'
    load File.dirname(__FILE__) + '/../../fixtures/shared/seeds.rb'

    ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/../../tmp/activerecord.log')
  end

  it_behaves_like 'by day'
  it_behaves_like 'by direction'
  it_behaves_like 'by fortnight'
  it_behaves_like 'by month'
  it_behaves_like 'by calendar month'
  it_behaves_like 'by quarter'
  it_behaves_like 'by week'
  it_behaves_like 'by weekend'
  it_behaves_like 'by year'
  it_behaves_like 'relative'
  it_behaves_like 'offset parameter'
  it_behaves_like 'scope parameter'

  it 'should be able to order the result set' do
    scope = Post.by_year(Time.zone.now.year, :order => 'created_at DESC')
    expect(scope.order_values).to eq ['created_at DESC']
  end

  describe '#between_times' do
    subject { Post.between_times(Time.parse('2014-01-01'), Time.parse('2014-01-06')) }
    it { expect be_a(ActiveRecord::Relation) }
    it { expect(subject.count).to eql(3) }
  end

  describe '#between' do
    subject { Post.between(Time.parse('2014-01-01'), Time.parse('2014-01-06')) }
    it 'should be an alias of #between_times' do
      expect(subject.count).to eql(3)
    end
  end
end if testing_active_record?
