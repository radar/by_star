module ByStar
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      protected

      def by_star_default_field
        "#{self.table_name}.created_at"
      end

      def by_star_point_query(scope, field, start_time, end_time)
        scope.where("#{field} >= ? AND #{field} <= ?", start_time, end_time)
      end

      def by_star_span_strict_query(scope, start_field, end_field, start_time, end_time)
        scope.where("#{start_field} >= ? AND #{start_field} <= ? AND #{end_field} >= ? AND #{end_field} <= ?", start_time, end_time, start_time, end_time)
      end

      def by_star_span_overlap_query(scope, start_field, end_field, start_time, end_time, options)
        scope.where("#{end_field} > ? AND #{start_field} < ?", start_time, end_time)
      end

      def by_star_before_query(scope, field, time)
        scope.where("#{field} <= ?", time)
      end

      def by_star_after_query(scope, field, time)
        scope.where("#{field} >= ?", time)
      end

      def by_star_order(scope, order)
        scope.order(order)
      end

      def oldest_query(options={})
        field = by_star_start_field(options)
        by_star_scope(options).reorder("#{field} ASC").first
      end

      def newest_query(options={})
        field = by_star_start_field(options)
        by_star_scope(options).reorder("#{field} DESC").first
      end
    end

    def previous(options={})
      field = self.class.by_star_start_field(options)
      value = self.send(field.split(".").last)
      self.class.by_star_scope(options.merge(scope_args: self)).where("#{field} < ?", value).reorder("#{field} DESC").first
    end

    def next(options={})
      field = self.class.by_star_start_field(options)
      value = self.send(field.split(".").last)
      self.class.by_star_scope(options.merge(scope_args: self)).where("#{field} > ?", value).reorder("#{field} ASC").first
    end
  end
end
