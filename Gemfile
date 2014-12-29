source 'http://rubygems.org'

gemspec

ar_version = ENV['ACTIVE_RECORD_VERSION']
ar_version = case ar_version
               when 'master' then {github: 'rails'}
               when String   then "~> #{ar_version}"
             end

mo_version = ENV['MONGOID_VERSION']
mo_version = case mo_version
               when 'master' then {github: 'mongoid'}
               when String   then "~> #{mo_version}"
             end

gem 'activerecord', ar_version if ar_version
gem 'mongoid',      mo_version if mo_version
