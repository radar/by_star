module ByStar
  module ByWeek

    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_week(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.new(options[:year], 1, 1).in_time_zone(Time.zone) if options[:year]
      time ||= Time.current
      send("by_week_#{time_klass(time)}", time, options)
    end

    private

    def by_week_Time_or_Date(time, options={})
      between(time.beginning_of_week, time.end_of_week, options)
    end
    alias_method :by_week_Time, :by_week_Time_or_Date
    alias_method :by_week_Date, :by_week_Time_or_Date

    def by_week_Fixnum(week, options={})
      time = Time.new(options[:year], 1, 1).in_time_zone(Time.zone) if options[:year]
      time ||= Time.current

      # This is the nescessary decrement as the beginning_of_year should be
      # the first-week (week-1). While the calculation of start_time will add
      # x amount of weeks to the beginning_of_year. (0-based week)
      week = week - 1
      start_time = time.beginning_of_year + week.to_i.weeks

      between(start_time, (start_time + 1.week).end_of_day, options)
    end
  end
end
