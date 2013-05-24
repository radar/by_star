require 'spec_helper'
Dir[File.dirname(__FILE__) + '/../shared/*.rb'].each {|file| require file }

describe ActiveRecord do
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
    load File.dirname(__FILE__) + "/../../fixtures/shared/seeds.rb"

    ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../../tmp/activerecord.log")
  end

  it_behaves_like "by day"
  it_behaves_like "by direction"
  it_behaves_like "by fortnight"
  it_behaves_like "by month"
  it_behaves_like "by quarter"
  it_behaves_like "by week"
  it_behaves_like "by weekend"
  it_behaves_like "by year"

  it "should be able to order the result set" do
    scope = Post.by_year(Time.zone.now.year, :order => "created_at DESC")
    scope.order_values.should == ["created_at DESC"]
  end

  describe "#between" do
    it "should return an ActiveRecord::Relation object" do
      Post.between(Date.today - 2, Date.today).class.should == ActiveRecord::Relation
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

  describe "#between_days" do
    it "should return an ActiveRecord::Relation object" do
      Post.between_days(Date.today - 2, Date.today).class.should == ActiveRecord::Relation
    end
    it "should return a result set between two times" do
      Post.between_days(Date.today - 2, Date.today).count.should == 5
    end
  end
end
