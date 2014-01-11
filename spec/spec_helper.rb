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
require 'timecop'
require 'by_star'

Time.zone = 'UTC'
Timecop.travel(Time.zone.local(2014))

def testing_mongoid?
  ENV['DB'] == 'mongodb' || ENV['DB'].nil?
end

def testing_active_record?
  ENV['DB'] != 'mongodb'
end
