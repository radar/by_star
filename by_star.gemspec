# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{by_star}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\304\207", "Ryan Bigg"]
  s.date = %q{2009-05-26}
  s.email = %q{radarlistener@gmail.com}
  s.files = ["Rakefile", "lib/by_star.rb", "spec/by_star_spec.rb", "spec/fixtures/models.rb", "spec/fixtures/schema.rb", "spec/spec_helper.rb", "rails/init.rb", "README.markdown", "MIT-LICENSE"]
  s.homepage = %q{http://github.com/radar/by_star}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{ActiveRecord extension for easier date scopes and time ranges}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
