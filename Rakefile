require 'rake'
begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  require 'spec'
end

require 'rake/rdoctask'
require 'spec/rake/spectask'
desc 'Default: run unit tests.'
task :default => :spec

desc "Run the specs under spec"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts << "-c"
end

desc 'Generate documentation for the by_star plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ByStar'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
