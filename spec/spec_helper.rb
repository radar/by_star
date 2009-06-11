# Inspiration gained from Thinking Sphinx's test suite.
# Pat Allan is a genius.

$:.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'activesupport'
require 'activerecord'
require 'frozenplague/by_star'
require 'spec'
require 'spec/fixtures/models'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone
ActiveRecord::Base.default_timezone = zone

require 'spec/test_helper'

FileUtils.mkdir_p "#{Dir.pwd}/tmp"

ActiveRecord::Base.logger = Logger.new(StringIO.new)

Spec::Runner.configure do |config|  
  
  test = TestHelper.new
  test.setup_mysql
  
end
