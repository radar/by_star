require 'rubygems'
require 'bundler'
Bundler.setup
require 'fileutils'
require 'logger'

FileUtils.mkdir_p(File.dirname(__FILE__) + "/tmp")
$:.unshift(File.join(File.dirname(__FILE__), "../lib"))

require 'active_record'
require 'mongoid'
require 'timecop'
require 'by_star'

# Specs should pass regardless of timezone
Time.zone = %w(Asia/Tokyo America/New_York UTC).sample
puts "Running specs in #{Time.zone} timezone..."

# Set Rails time to 2014-01-01 00:00:00
Timecop.travel(Time.zone.local(2014))

def testing_mongoid?
  ENV['DB'] == 'mongodb' || ENV['DB'].nil?
end

def testing_active_record?
  ENV['DB'] != 'mongodb'
end
