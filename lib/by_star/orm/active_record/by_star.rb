module ByStar
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      include ::ByStar::Base

      # Returns all records between a given start and finish time.
      #
      # Currently only supports Time objects.
      def between(start, finish, options={})
        start_field = by_star_start_field
        end_field   = by_star_end_field
        scope = where("#{end_field} >= ? AND #{start_field} <= ?", start, finish)
        scope = scope.order(options[:order]) if options[:order]
        scope
      end
      alias_method :between_times, :between

      protected

      def by_star_field_created_at_field
        "#{self.table_name}.created_at"
      end

      # override private methods in ByStar::ByDirection
      def before_Time_or_Date(time_or_date, options={})
        field = by_star_start_field
        where("#{field} <= ?", time_or_date)
      end
      alias_method :before_Time, :before_Time_or_Date
      alias_method :before_Date, :before_Time_or_Date

      def after_Time_or_Date(time_or_date, options={})
        field = by_star_end_field
        where("#{field} >= ?", time_or_date)
      end
      alias_method :after_Time, :after_Time_or_Date
      alias_method :after_Date, :after_Time_or_Date
    end

    # override ByStar::InstanceMethods methods
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
