require 'by_star/by_year'
require 'by_star/by_month'

module ByStar

  def by_star_field(field=nil)
    @by_star_field ||= field
    @by_star_field || "#{self.table_name}.created_at"
  end

  include ByYear
  include ByMonth

  class ParseError < StandardError

  end

  def between(start, finish, options={})
    field = options[:field] || by_star_field
    scope = where("#{field} >= ? AND #{field} <= ?",
              start, finish)
    scope = scope.order(options[:order]) if options[:order]
    scope
  end

  private

  def time_klass(time)
    case time
    when ActiveSupport::TimeWithZone
      Time
    else
      time.class
    end
  end

end

ActiveRecord::Base.send :extend, ByStar
ActiveRecord::Relation.send :extend, ByStar
