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
        start_field = by_star_start_field(options)
        end_field = by_star_end_field(options)

        scope = by_star_scope(options)
        scope = if options[:strict] || start_field == end_field
          scope.gte(start_field => start).lte(end_field => finish)
        else
          scope.gt(end_field => start).lt(start_field => finish)
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
        field = by_star_start_field(options)
        by_star_scope(options).lte(field => time)
      end

      def after_query(time, options={})
        field = by_star_start_field(options)
        by_star_scope(options).gte(field => time)
      end

      def oldest_query(options={})
        field = by_star_start_field(options)
        by_star_scope(options).all.reorder(field => :asc).first
      end

      def newest_query(options={})
        field = by_star_start_field(options)
        by_star_scope(options).all.reorder(field => :desc).first
      end
    end

    def previous(options={})
      field = self.class.by_star_start_field
      self.class.by_star_scope(options.merge(scope_args: self)).lt(field => self.send(field)).reorder(field => :desc).first
    end

    def next(options={})
      field = self.class.by_star_start_field
      self.class.by_star_scope(options.merge(scope_args: self)).gt(field => self.send(field)).reorder(field => :asc).first
    end
  end
end
