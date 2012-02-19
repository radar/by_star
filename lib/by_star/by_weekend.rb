module ByStar
  module ByWeekend
    def by_weekend(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.now
      send("by_weekend_#{time_klass(time)}", time, options)
    end

    private

    def by_weekend_Time(time, options={})
      between(time.beginning_of_weekend, time.end_of_weekend)
    end

  end
end
