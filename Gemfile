source "http://rubygems.org"

# Specify your gem's dependencies in by_star.gemspec
gemspec

active_record_version = ENV['ACTIVE_RECORD_VERSION'] || 'default'

active_record_opts =
  case active_record_version
  when 'master'
    {github: 'rails/rails'}
  when 'default'
    '~> 3.0'
  else
    "~> #{active_record_version}"
  end

mongoid_version = ENV['MONGOID_VERSION'] || 'default'

mongoid_opts =
  case mongoid_version
  when 'master'
    {github: 'mongoid/mongoid'}
  when 'default'
    '~> 3.0'
  else
    "~> #{mongoid_version}"
  end

gem 'activerecord', active_record_opts
gem 'mongoid', mongoid_opts if Gem::Version.create(RUBY_VERSION.dup) >= Gem::Version.create('1.9.3')
