# Inspiration gained from Thinking Sphinx's test suite.
# Pat Allan is a genius.

$:.unshift File.dirname(__FILE__) + '/../lib'

require 'rubygems'
require 'spec/test_helper'
require 'frozenplague/by_month'

FileUtils.mkdir_p "#{Dir.pwd}/tmp"

ActiveRecord::Base.logger = Logger.new(StringIO.new)

Spec::Runner.configure do |config|  
  
  test = TestHelper.new
  test.setup_mysql
  
  require 'spec/fixtures/models'
  
end
