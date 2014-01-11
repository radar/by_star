module ByStar
  module ByWeek

    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_week(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year]) if options[:year]
      time ||= Time.zone.now
      time = ByStar::Normalization.week(time, options)
      by_week_query(time, options)
    end

    private

    def by_week_query(time, options={})
      start_day = Array(options[:start_day])
      between(time.beginning_of_week(*start_day), time.end_of_week(*start_day), options)
    end
  end
end
