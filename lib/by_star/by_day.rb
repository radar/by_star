module ByStar
  module ByDay
    def by_day(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      send("by_day_#{time_klass(time)}", time, options)
    end

    def today(options={})
      by_day_Time(Time.zone.now, options)
    end

    def yesterday(options={})
      by_day_Time(Time.zone.now.yesterday, options)
    end

    def tomorrow(options={})
      by_day_Time(Time.zone.now.tomorrow, options)
    end

    private

    def by_day_Time(time, options)
      between(time.beginning_of_day, time.end_of_day, options)
    end

  end
end
