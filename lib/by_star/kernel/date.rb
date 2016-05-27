module ByStar

  module Kernel

    module Date
      extend ActiveSupport::Concern

      included do

        # Shim to alias Rails 3 #to_time_in_current_zone to Rails 4 name #in_time_zone
        if method_defined?(:to_time_in_current_zone) && !method_defined?(:in_time_zone)
          alias_method :in_time_zone, :to_time_in_current_zone
        end
      end

      # A "Weekend" is defined as beginning of Saturday to end of Sunday.
      # The weekend for a given date will be the the next weekend if the day Mon-Thurs,
      # otherwise the current weekend if the day is Fri-Sun.
      def beginning_of_weekend
        beginning_of_week(:monday).advance(days: 5)
      end

      def end_of_weekend
        beginning_of_weekend + 1
      end

      # A "Fortnight" is defined as a two week period, with the first fortnight of the
      # year beginning on 1st January.
      def beginning_of_fortnight
        beginning_of_year + 14 * ((self - beginning_of_year) / 14).to_i
      end

      def end_of_fortnight
        beginning_of_fortnight + 13
      end

      # A "Calendar Month" is defined as a month as it appears on a calendar, including days form
      # previous/following months which are part of the first/last weeks of the given month.
      def beginning_of_calendar_month(*args)
        beginning_of_month.beginning_of_week(*args)
      end

      def end_of_calendar_month(*args)
        end_of_month.end_of_week(*args)
      end
    end
  end
end

::Date.__send__(:include, ByStar::Kernel::Date)
