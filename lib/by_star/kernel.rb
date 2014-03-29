module ByStar

  module Kernel

    module Time

      # A "Weekend" is defined as the 60-hour period from 15:00 Friday to 03:00 Monday.
      # The weekend for a given date will be the the next weekend if the day Mon-Thurs,
      # otherwise the current weekend if the day is Fri-Sun.
      def beginning_of_weekend
        beginning_of_week(:monday).advance(:days => 4) + 15.hours
      end

      def end_of_weekend
        (beginning_of_weekend + 59.hours).end_of_hour
      end

      # A "Fortnight" is defined as a two week period, with the first fortnight of the
      # year beginning on 1st January.
      def beginning_of_fortnight
        (beginning_of_year.to_date + 14 * ((self - beginning_of_year) / 2.weeks).to_i).beginning_of_day
      end

      def end_of_fortnight
        (beginning_of_fortnight.to_date + 13).end_of_day
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
