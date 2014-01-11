require 'rubygems'
require 'bundler'
Bundler.setup
require 'fileutils'
require 'logger'

FileUtils.mkdir_p(File.dirname(__FILE__) + "/tmp")
$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'active_record'
require 'mongoid' if Gem::Version.create(RUBY_VERSION.dup) >= Gem::Version.create('1.9.3')
require 'active_support'
require 'active_support/core_ext/string/conversions'
require 'by_star'
require 'timecop'


# Define time zone before loading test_helper
Time.zone = 'UTC'

# Freeze time to Jan 1st of this year
Timecop.travel(Time.zone.local(Time.zone.now.year, 1, 1, 0, 0, 1, 0))

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

#
# Tests should be according to the database specified at runtime
#

def testing_mongoid?
  ENV['DB'] == 'mongodb' || ENV['DB'].nil?
end

def testing_active_record?
  ENV['DB'] != 'mongodb'
end
