# In keeping with Mongoid standards, this module must be included into your model class, i.e.
#
#   include Mongoid::ByStar
#
module Mongoid
  module ByStar
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      alias_method :original_by_star_end_field, :by_star_end_field
      alias_method :original_by_star_start_field, :by_star_start_field

      def by_star_end_field(options = {})
        database_field_name original_by_star_end_field(options)
      end

      def by_star_start_field(options = {})
        database_field_name original_by_star_start_field(options)
      end

      def by_star_default_field
        :created_at
      end

      protected

      def by_star_point_query(scope, field, start_time, end_time)
        range = start_time..end_time
        scope.where(field => range)
      end

      def by_star_span_strict_query(scope, start_field, end_field, start_time, end_time)
        range = start_time..end_time
        scope.where(start_field => range).where(end_field => range)
      end

      def by_star_span_overlap_query(scope, start_field, end_field, start_time, end_time, options)
        scope.gt(end_field => start_time).lt(start_field => end_time)
      end

      def by_star_before_query(scope, field, time)
        scope.lte(field => time)
      end

      def by_star_after_query(scope, field, time)
        scope.gte(field => time)
      end

      def by_star_order(scope, order)
        scope.order_by(order)
      end

      def oldest_query(options={})
        field = by_star_start_field(options)
        all.reorder(field => :asc).first
      end

      def newest_query(options={})
        field = by_star_start_field(options)
        all.reorder(field => :desc).first
      end
    end

    def previous(options={})
      field = self.class.by_star_start_field(options)
      self.class.lt(field => self.send(field)).reorder(field => :desc).first
    end

    def next(options={})
      field = self.class.by_star_start_field(options)
      self.class.gt(field => self.send(field)).reorder(field => :asc).first
    end
  end
end
