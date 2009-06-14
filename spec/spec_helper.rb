require "activerecord"

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

require 'rubygems'
require 'activesupport'
require 'by_star'
require 'spec'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = zone

load "fixtures/schema.rb"
load "fixtures/models.rb"

# bootstraping the plugin through init.rb
# tests how it would load in a real application
load File.dirname(__FILE__) + "/../rails/init.rb"
