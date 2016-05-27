module ByStar

  module Kernel

    module Time

      # A "Weekend" is defined as beginning of Saturday to end of Sunday.
      # The weekend for a given date will be the the next weekend if the day Mon-Thurs,
      # otherwise the current weekend if the day is Fri-Sun.
      def beginning_of_weekend
        beginning_of_week(:monday).advance(days: 5)
      end

      def end_of_weekend
        (beginning_of_weekend + 47.hours).end_of_hour
      end

      # A "Fortnight" is defined as a two week period, with the first fortnight of the
      # year beginning on 1st January.
      def beginning_of_fortnight
        (beginning_of_year + 1.fortnight * ((self - beginning_of_year) / 1.fortnight).to_i).beginning_of_day
      end

      def end_of_fortnight
        (beginning_of_fortnight + 13.days).end_of_day
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

::Time.__send__(:include, ByStar::Kernel::Time)
