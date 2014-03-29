require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

def orm_test(orm)
  RSpec::Core::RakeTask.new(orm) do |task|
    task.pattern = "./spec/{unit,integration/#{orm}}/{,/*/**}/*_spec.rb"
  end
end

namespace :spec do
  orm_test 'active_record'
  orm_test 'mongoid'
end

task default: :spec
