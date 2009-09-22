require 'rubygems'
require 'activerecord'
require 'fileutils'
FileUtils.mkdir_p("tmp")
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Base.logger = Logger.new("tmp/activerecord.log")
$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'activesupport'
require 'by_star'
require 'spec'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = zone

load File.dirname(__FILE__) + "/fixtures/schema.rb"
load File.dirname(__FILE__) + "/fixtures/models.rb"

# bootstraping the plugin through init.rb
# tests how it would load in a real application
load File.dirname(__FILE__) + "/../rails/init.rb"
