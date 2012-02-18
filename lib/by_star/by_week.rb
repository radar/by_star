module ByStar
  module ByWeek

    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_week(time=Time.zone.now)
      send("by_star_#{time_klass(time)}", time)
    end

    def by_week_Time(time)
      between(time.beginning_of_week, time.end_of_week)
    end
  end
end
