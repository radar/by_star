module ByStar
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      # Returns all records between a given start and finish time.
      #
      # Currently only supports Time objects.
      def between_times_query(start, finish, options={})
        start_field = by_star_start_field(options)
        end_field = by_star_end_field(options)

        scope = if options[:strict] || start_field == end_field
          where("#{start_field} >= ? AND #{end_field} <= ?", start, finish)
        else
          where("#{end_field} > ? AND #{start_field} < ?", start, finish)
        end
        scope = scope.order(options[:order]) if options[:order]
        scope
      end

      def between(*args)
        ActiveSupport::Deprecation.warn 'ByStar `between` method will be removed in v3.0.0. Please use `between_times`'
        between_times(*args)
      end

      protected

      def by_star_default_field
        "#{self.table_name}.created_at"
      end

      def before_query(time, options={})
        field = by_star_start_field
        where("#{field} <= ?", time)
      end

      def after_query(time, options={})
        field = by_star_start_field
        where("#{field} >= ?", time)
      end
    end

    def previous(options={})
      field = self.class.by_star_start_field
      value = self.send(field.split(".").last)
      self.class.where("#{field} < ?", value).reorder("#{field} DESC").first
    end

    def next(options={})
      field = self.class.by_star_start_field
      value = self.send(field.split(".").last)
      self.class.where("#{field} > ?", value).reorder("#{field} ASC").first
    end
  end
end
