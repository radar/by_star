# -*- encoding: utf-8 -*-
require File.expand_path("../lib/by_star/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "by_star"
  s.version     = ByStar::VERSION
  s.authors     = ["Ryan Bigg", "Johnny Shields"]
  s.email       = ["radarlistener@gmail.com"]
  s.homepage    = "http://github.com/radar/by_star"
  s.summary     = "ActiveRecord and Mongoid extension for easier date scopes and time ranges"
  s.description = "ActiveRecord and Mongoid extension for easier date scopes and time ranges"

  s.required_ruby_version = '>= 2.0.0'

  s.post_install_message = File.read('UPGRADING') if File.exists?('UPGRADING')

  s.add_dependency "activesupport", "> 3"

  s.add_development_dependency "chronic"
  s.add_development_dependency "bundler"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "activerecord"
  s.add_development_dependency "mongoid"
  s.add_development_dependency "pg"
  s.add_development_dependency "mysql2", "~> 0.3.10"
  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "timecop", "~> 0.3"
  s.add_development_dependency "pry"

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
end
