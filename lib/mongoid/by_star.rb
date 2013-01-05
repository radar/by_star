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
      field = options[:field] || by_star_field
      scope = where(field.to_sym.gte => start).where(field.to_sym.lte => finish)
      scope = scope.order_by([[field.to_sym, options[:order]]]) if options[:order]
      scope
    end

    # override private methods in ByStar::ByDirection
    def before_Time_or_Date(time_or_date, options={})
      field = options[:field] || by_star_field
      where(field.to_sym.lte => time_or_date)
    end
    alias_method :before_Time, :before_Time_or_Date
    alias_method :before_Date, :before_Time_or_Date

    def before_String(string, options={})
      field = options[:field] || by_star_field
      if time = Chronic.parse(string)
        where(field.to_sym.lte => time)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end

    def after_Time_or_Date(time_or_date, options={})
      field = options[:field] || by_star_field
      where(field.to_sym.gte => time_or_date)
    end
    alias_method :after_Time, :after_Time_or_Date
    alias_method :after_Date, :after_Time_or_Date

    def after_String(string, options={})
      field = options[:field] || by_star_field
      if time = Chronic.parse(string)
        where(field.to_sym.gte => time)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end
  end

  include ByStar::InstanceMethods

  # override ByStar::InstanceMethods methods
  def previous(options={})
    field = options[:field] || self.class.by_star_field
    self.class.where(field.to_sym.lt => self.send(field)).order_by([[field, :desc]]).first
  end

  def next(options={})
    field = options[:field] || self.class.by_star_field
    self.class.where(field.to_sym.gt => self.send(field)).order_by([[field, :asc]]).first
  end
end
