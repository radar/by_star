module Mongoid::ByStar
  extend ActiveSupport::Concern

  module ClassMethods
    include ByStar

    def by_star_field(field=nil)
      @by_star_field ||= field
      @by_star_field || :created_at
    end

    # override ByStar method
    def between(start, finish, options={})
      field = (options[:field] || by_star_field).to_sym
      scope = gte(field => start).lte(field => finish)
      scope = scope.order_by(field => options[:order]) if options[:order]
      scope
    end
    alias_method :between_times, :between

    # override private methods in ByStar::ByDirection
    def before_Time_or_Date(time_or_date, options={})
      field = (options[:field] || by_star_field).to_sym
      lte(field => time_or_date)
    end
    alias_method :before_Time, :before_Time_or_Date
    alias_method :before_Date, :before_Time_or_Date

    def before_String(string, options={})
      field = (options[:field] || by_star_field).to_sym
      if time = Chronic.parse(string)
        lte(field => time)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end

    def after_Time_or_Date(time_or_date, options={})
      field = (options[:field] || by_star_field).to_sym
      gte(field => time_or_date)
    end
    alias_method :after_Time, :after_Time_or_Date
    alias_method :after_Date, :after_Time_or_Date

    def after_String(string, options={})
      field = (options[:field] || by_star_field).to_sym
      if time = Chronic.parse(string)
        gte(field => time)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end
  end

  include ByStar::InstanceMethods

  # override ByStar::InstanceMethods methods
  def previous(options={})
    field = (options[:field] || self.class.by_star_field).to_sym
    self.class.lt(field => self.send(field)).desc(field).first
  end

  def next(options={})
    field = (options[:field] || self.class.by_star_field).to_sym
    self.class.gt(field => self.send(field)).asc(field).first
  end
end
