module ByStar
  module ByWeekend
    def by_weekend(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.now
      time = ByStar::Normalization.week(time, options)
      by_weekend_query(time, options)
    end

    private

    def by_weekend_query(time, options={})
      between(time.beginning_of_weekend, time.end_of_weekend)
    end
  end
end
