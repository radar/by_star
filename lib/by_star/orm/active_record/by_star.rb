module ByStar
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      # Returns all records between a given start and finish time.
      #
      # Currently only supports Time objects.
      def between_times_query(start, finish, options={})
        scope = if options[:strict] || by_star_start_field == by_star_end_field
          where("#{by_star_start_field} >= ? AND #{by_star_end_field} <= ?", start, finish)
        else
          where("#{by_star_end_field} > ? AND #{by_star_start_field} < ?", start, finish)
        end
        scope = scope.order(options[:order]) if options[:order]
        scope
      end

      alias_method :between, :between_times

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
      field = field.split(".").last
      self.class.where("#{field} < ?", self.send(field)).reorder("#{field} DESC").first
    end

    def next(options={})
      field = self.class.by_star_start_field
      field = field.split(".").last
      self.class.where("#{field} > ?", self.send(field)).reorder("#{field} ASC").first
    end
  end
end
