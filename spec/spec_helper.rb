require 'rubygems'
require 'active_record'
require 'fileutils'
require 'logger'
FileUtils.mkdir_p("tmp")

$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'active_support'
require 'active_support/core_ext/string/conversions'
require 'by_star'
require 'spec'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = zone

# bootstraping the plugin through init.rb
# tests how it would load in a real application
load File.dirname(__FILE__) + "/../rails/init.rb"

YAML::load_file(File.dirname(__FILE__) + "/database.yml").each do |key, connection|
  ActiveRecord::Base.establish_connection(connection)
  load File.dirname(__FILE__) + "/fixtures/schema.rb"
  load File.dirname(__FILE__) + "/fixtures/models.rb"
end

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