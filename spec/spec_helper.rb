require 'rubygems'
require 'bundler'
Bundler.setup
require 'fileutils'
require 'logger'

FileUtils.mkdir_p(File.dirname(__FILE__) + "/tmp")
$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'active_record'
require 'mongoid' if Gem::Version.create(RUBY_VERSION.dup) >= Gem::Version.create('1.9.3')
require 'by_star'
require 'timecop'

# Define time zone before loading test_helper
zone = "UTC"
Time.zone = zone

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
