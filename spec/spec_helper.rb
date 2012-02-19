require 'rubygems'
require 'bundler'
Bundler.setup
require 'active_record'
require 'fileutils'
require 'logger'
FileUtils.mkdir_p("tmp")

$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'active_support'
require 'active_support/core_ext/string/conversions'
require 'by_star'
require 'rspec'
require 'timecop'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = :utc

ActiveRecord::Base.configurations = YAML::load_file(File.dirname(__FILE__) + "/database.yml")
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite")
load File.dirname(__FILE__) + "/fixtures/schema.rb"

# Freeze time to Jan 1st of this year
Timecop.travel(Time.zone.local(Time.zone.now.year, 1, 1, 0, 0, 1, 0))
load File.dirname(__FILE__) + "/fixtures/models.rb"


# Print the location of puts/p calls so you can find them later
# def puts str
#   super caller.first if caller.first.index("shoulda.rb") == -1
#   super str
# end
# 
# def p obj
#   puts caller.first
#   super obj
# end

ActiveRecord::Base.logger = Logger.new("tmp/activerecord.log")
