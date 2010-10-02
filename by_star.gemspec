# -*- encoding: utf-8 -*-
require File.expand_path("../lib/by_star/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "by_star"
  s.version     = ByStar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = []
  s.email       = []
  s.homepage    = "http://rubygems.org/gems/by_star"
  s.summary     = "ActiveRecord extension for easier date scopes and time ranges"
  s.description = "ActiveRecord extension for easier date scopes and time ranges"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "by_star"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_dependency "activerecord", ">= 2.0.0"
  s.add_dependency "chronic"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
