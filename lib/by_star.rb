require 'by_star/kernel/time'
require 'by_star/normalization'
require 'by_star/by_direction'
require 'by_star/by_year'
require 'by_star/by_month'
require 'by_star/by_calendar_month'
require 'by_star/by_fortnight'
require 'by_star/by_week'
require 'by_star/by_weekend'
require 'by_star/by_day'
require 'by_star/by_quarter'
require 'by_star/base'

if defined?(ActiveRecord)
  require 'by_star/orm/active_record/by_star'
  ActiveRecord::Base.send :include, ByStar::ActiveRecord
  ActiveRecord::Relation.send :extend, ByStar::ActiveRecord::ClassMethods
end

if defined?(Mongoid)
  require 'by_star/orm/mongoid/by_star'
end
