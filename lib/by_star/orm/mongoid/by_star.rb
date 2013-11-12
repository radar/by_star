# In keeping with Mongoid standards, this module must be included into your model class, i.e.
#
#   include Mongoid::ByStar
#
module Mongoid
  module ByStar
    extend ActiveSupport::Concern

    include ::ByStar::Base

    module ClassMethods

      # override ByStar method
      def between(start, finish, options={})
        start_field, end_field = by_star_fields_class(options)
        scope = gte(end_field => start).lte(start_field => finish)
        scope = scope.order_by(field => options[:order]) if options[:order]
        scope
      end
      alias_method :between_times, :between

      protected

      # override base method to add database_field_name
      def by_star_fields_class(options={})
        start_field = options[:field] || by_star_start_field
        end_field = options[:end_field] || options[:field] || by_star_end_field
        [start_field, end_field].map{|f| database_field_name(f)}
      end

      def by_star_field_created_at_field
        :created_at
      end

      # override private methods in ByStar::ByDirection
      def before_Time_or_Date(time_or_date, options={})
        field = by_star_fields_class(options).first
        lte(field => time_or_date)
      end
      alias_method :before_Time, :before_Time_or_Date
      alias_method :before_Date, :before_Time_or_Date

      def after_Time_or_Date(time_or_date, options={})
        field = by_star_fields_class(options).last
        gte(field => time_or_date)
      end
      alias_method :after_Time, :after_Time_or_Date
      alias_method :after_Date, :after_Time_or_Date
    end

    # override base method to add database_field_name
    def by_star_fields_instance(options={})
      start_field = options[:field] || self.class.by_star_start_field
      end_field = options[:end_field] || options[:field] || self.class.by_star_end_field
      [start_field, end_field].map{|f| self.class.database_field_name(f)}
    end

    # override ByStar::InstanceMethods methods
    def previous(options={})
      field = by_star_fields_instance(options).first
      self.class.lt(field => self.send(field)).desc(field).first
    end

    def next(options={})
      field = by_star_fields_instance(options).first
      self.class.gt(field => self.send(field)).asc(field).first
    end
  end
end
