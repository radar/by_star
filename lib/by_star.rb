require 'by_star/kernel/time'
require 'by_star/kernel/date'
require 'by_star/normalization'
require 'by_star/between'
require 'by_star/directional'
require 'by_star/base'

if defined?(ActiveRecord)
  require 'by_star/orm/active_record/by_star'
  ActiveRecord::Base.send :include, ByStar::ActiveRecord
  ActiveRecord::Relation.send :extend, ByStar::ActiveRecord::ClassMethods
end

if defined?(Mongoid)
  require 'by_star/orm/mongoid/by_star'
end
