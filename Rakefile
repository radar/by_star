desc "generates .gemspec file"
task :gemspec => "version:read" do
  spec = Gem::Specification.new do |gem|
    gem.name = "by_star"
    gem.summary = "ActiveRecord extension for easier date scopes and time ranges"
    gem.email = "mislav.marohnic@gmail.com"
    gem.homepage = "http://github.com/mislav/by_star"
    gem.authors = ["Mislav Marohnić", "Ryan Bigg"]
    gem.has_rdoc = true
    
    gem.version = GEM_VERSION
    gem.files = FileList['Rakefile', '{lib,spec,rails}/**/*', 'README*', '*LICENSE*'].reject do |file|
      File.directory?(file)
    end
    gem.executables = Dir['bin/*'].map { |f| File.basename(f) }
  end
  
  spec_string = spec.to_ruby
  
  begin
    Thread.new { eval("$SAFE = 3\n#{spec_string}", binding) }.join 
  rescue
    abort "unsafe gemspec: #{$!}"
  else
    File.open("#{spec.name}.gemspec", 'w') { |file| file.write spec_string }
  end
end

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
  t.libs = %w(lib spec)
  t.spec_opts << "-c"
  t.ruby_opts << "-rubygems"
end

desc 'Generate documentation for the by_star plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ByStar'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :bump => ["version:bump", :gemspec]

namespace :version do
  task :read do
    unless defined? GEM_VERSION
      GEM_VERSION = File.read("VERSION")
    end
  end
  
  task :bump => :read do
    if ENV['VERSION']
      GEM_VERSION.replace ENV['VERSION']
    else
      GEM_VERSION.sub!(/\d+$/) { |num| num.to_i + 1 }
    end
    
    File.open("VERSION", 'w') { |v| v.write GEM_VERSION }
  end
end

task :release => :bump do
  system %(git add VERSION *.gemspec && git commit -m "release v#{GEM_VERSION}")
  system %(git tag -am "release v#{GEM_VERSION}" v#{GEM_VERSION})
end
