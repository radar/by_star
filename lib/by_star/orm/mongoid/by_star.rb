# In keeping with Mongoid standards, this module must be included into your model class, i.e.
#
#   include Mongoid::ByStar
#
module Mongoid
  module ByStar
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      def between_times_query(start, finish, options={})
        scope = if options[:strict] || by_star_start_field == by_star_end_field
          gte(by_star_start_field => start).lte(by_star_end_field => finish)
        else
          gt(by_star_end_field => start).lt(by_star_start_field => finish)
        end
        scope = scope.order_by(field => options[:order]) if options[:order]
        scope
      end

      def by_star_end_field_with_mongoid(options = {})
        database_field_name by_star_end_field_without_mongoid(options)
      end
      alias_method_chain :by_star_end_field, :mongoid

      def by_star_start_field_with_mongoid(options = {})
        database_field_name by_star_start_field_without_mongoid(options)
      end
      alias_method_chain :by_star_start_field, :mongoid

      protected

      def by_star_default_field
        :created_at
      end

      def before_query(time, options={})
        field = by_star_start_field
        lte(field => time)
      end

      def after_query(time, options={})
        field = by_star_start_field
        gte(field => time)
      end
    end

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
