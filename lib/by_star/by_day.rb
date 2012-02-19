module ByStar
  module ByDay
    def by_day(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      send("by_day_#{time_klass(time)}", time, options)
    end

    private

    def by_day_Time_or_Date(time, options)
      between(time.beginning_of_day, time.end_of_day, options)
    end
    alias_method :by_day_Time, :by_day_Time_or_Date
    alias_method :by_day_Date, :by_day_Time_or_Date


  end
end
