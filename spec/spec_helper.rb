require 'rubygems'
require 'activerecord'
require 'fileutils'
FileUtils.mkdir_p("tmp")

ActiveRecord::Base.logger = Logger.new("tmp/activerecord.log")
$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'activesupport'
require 'by_star'
require 'spec'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = zone

YAML::load_file(File.dirname(__FILE__) + "/database.yml").each do |key, connection|
  ActiveRecord::Base.establish_connection(connection)
  load File.dirname(__FILE__) + "/fixtures/schema.rb"
  load File.dirname(__FILE__) + "/fixtures/models.rb"
end

# bootstraping the plugin through init.rb
# tests how it would load in a real application
load File.dirname(__FILE__) + "/../rails/init.rb"
