module ByStar
  module ByWeek

    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_week(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      send("by_week_#{time_klass(time)}", time, options)
    end

    private

    def by_week_Time_or_Date(time, options={})
      between(time.beginning_of_week, time.end_of_week, options)
    end
    alias_method :by_week_Time, :by_week_Time_or_Date
    alias_method :by_week_Date, :by_week_Time_or_Date

    def by_week_Fixnum(week, options={})
      time = Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      start_time = time.beginning_of_year + week.to_i.weeks
      between(start_time, start_time + 1.week, options)
    end
  end
end
