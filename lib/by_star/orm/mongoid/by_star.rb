# In keeping with Mongoid standards, this module must be included into your model class, i.e.
#
#   include Mongoid::ByStar
#
module Mongoid
  module ByStar
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      def between(start, finish, options={})
        start_field = by_star_start_field
        end_field   = by_star_end_field
        scope = gte(end_field => start).lte(start_field => finish)
        scope = scope.order_by(field => options[:order]) if options[:order]
        scope
      end
      alias_method :between_times, :between

      def by_star_end_field_with_mongoid(options = {})
        database_field_name by_star_end_field_without_mongoid(options)
      end
      alias_method_chain :by_star_end_field, :mongoid

      def by_star_start_field_with_mongoid(options = {})
        database_field_name by_star_start_field_without_mongoid(options)
      end
      alias_method_chain :by_star_start_field, :mongoid

      protected

      def by_star_field_created_at_field
        :created_at
      end

      # override private methods in ByStar::ByDirection
      def before_Time_or_Date(time_or_date, options={})
        field = by_star_start_field
        lte(field => time_or_date)
      end
      alias_method :before_Time, :before_Time_or_Date
      alias_method :before_Date, :before_Time_or_Date

      def after_Time_or_Date(time_or_date, options={})
        field = by_star_start_field
        gte(field => time_or_date)
      end
      alias_method :after_Time, :after_Time_or_Date
      alias_method :after_Date, :after_Time_or_Date
    end

    # override ByStar::InstanceMethods methods
    def previous(options={})
      field = self.class.by_star_start_field
      self.class.lt(field => self.send(field)).desc(field).first
    end

    def next(options={})
      field = self.class.by_star_start_field
      self.class.gt(field => self.send(field)).asc(field).first
    end
  end
end
