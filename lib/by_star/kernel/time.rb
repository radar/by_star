module ByStar
  module Kernel
    module Time

      # A "Weekend" is defined as the 60-hour period from 15:00 Friday to 03:00 Monday.
      # The weekend for a given date will be the the next weekend if the day Tues-Thurs,
      # otherwise the current/previous weekend if the day is Fri-Mon.
      def beginning_of_weekend
        friday = case self.wday
                   when 0
                     self.end_of_week.beginning_of_day.advance(:days => -2)
                   when 5
                     self.beginning_of_day
                   else
                     self.beginning_of_week.advance(:days => 4)
                 end
        (friday + 15.hours)
      end

      def end_of_weekend
        beginning_of_weekend + 60.hours
      end

      # A "Fortnight" is defined as a two week period, with the first fortnight of the
      # year beginning on 1st January.
      def beginning_of_fortnight
        beginning_of_year + ((self - beginning_of_year) / 2.weeks) * 2.weeks
      end

      def end_of_fortnight
        (beginning_of_fortnight + 2.weeks).end_of_day
      end

      # A "Calendar Month" is defined as a month as it appears on a calendar, including days
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

::Time.__send__(:include, ByStar::Kernel::Time)
