require 'chronic'

require 'by_star/time_ext'
require 'by_star/instance_methods'

require 'by_star/by_direction'
require 'by_star/by_year'
require 'by_star/by_month'
require 'by_star/by_fortnight'
require 'by_star/by_week'
require 'by_star/by_weekend'
require 'by_star/by_day'
require 'by_star/by_quarter'

module ByStar

  def by_star_field(field=nil)
    @by_star_field ||= field
    @by_star_field || "#{self.table_name}.created_at"
  end

  include ByDirection
  include ByYear
  include ByMonth
  include ByFortnight
  include ByWeek
  include ByWeekend
  include ByDay
  include ByQuarter

  class ParseError < StandardError

  end

  # Returns all records between a given start and finish time.
  #
  # Currently only supports Time objects.
  def between(start, finish, options={})
    field = options[:field] || by_star_field
    scope = where("#{field} >= ? AND #{field} <= ?",
              start, finish)
    scope = scope.order(options[:order]) if options[:order]
    scope
  end
  alias_method :between_times, :between

  def between_days(start, finish, options={})
    between_times(start.beginning_of_day,finish.end_of_day,options)
  end

  private

  # Used inside the by_* methods to determine what kind of object "time" is.
  # These methods take the result of the time_klass method, and call other methods
  # using it, such as by_year_Time and by_year_String.
  def time_klass(time)
    case time
    when ActiveSupport::TimeWithZone
      Time
    else
      time.class
    end
  end

end

if defined?(ActiveRecord)
  ActiveRecord::Base.send :extend, ByStar
  ActiveRecord::Relation.send :extend, ByStar
  ActiveRecord::Base.send :include, ByStar::InstanceMethods
end

if defined?(Mongoid)
  require 'mongoid/by_star'
end
