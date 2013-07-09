# -*- encoding: utf-8 -*-
require File.expand_path("../lib/by_star/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "by_star"
  s.version     = ByStar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Bigg"]
  s.email       = ["radarlistener@gmail.com"]
  s.homepage    = "http://github.com/radar/by_star"
  s.summary     = "ActiveRecord extension for easier date scopes and time ranges"
  s.description = "ActiveRecord extension for easier date scopes and time ranges"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "by_star"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pg"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails", "~> 2.8"
  s.add_development_dependency "timecop", "~> 0.3"
  s.add_development_dependency "mongoid", "~> 3.0" if Gem::Version.create(RUBY_VERSION.dup) >= Gem::Version.create('1.9.3')
  s.add_development_dependency "pry"

  s.add_dependency "activerecord", "~> 3.0"
  s.add_dependency "chronic"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
