module ByStar
  module ByDay
    def by_day(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      time = ByStar::Normalization.time(time)
      by_day_query(time, options)
    end

    def today(options={})
      by_day_query(Time.zone.now, options)
    end

    def yesterday(options={})
      by_day_query(Time.zone.now.yesterday, options)
    end

    def tomorrow(options={})
      by_day_query(Time.zone.now.tomorrow, options)
    end

    protected

    def by_day_query(time, options)
      between(time.beginning_of_day, time.end_of_day, options)
    end
  end
end
