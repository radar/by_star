module ByStar
  module ByMonth
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_month(*args)
      options = args.extract_options!
      time = args.first || Time.zone.now
      time = ByStar::Normalization.month(time, options)
      by_month_query(time, false, options)
    end

    def by_calendar_month(*args)
      options = args.extract_options!
      time = args.first || Time.zone.now
      time = ByStar::Normalization.month(time, options)
      by_month_query(time, true, options)
    end

    private

    def by_month_query(time, is_calendar=false, options={})
      if is_calendar
        start_day = Array(options[:start_day])
        between(time.beginning_of_month.beginning_of_week(*start_day), time.end_of_month.end_of_week(*start_day), options)
      else
        between(time.beginning_of_month, time.end_of_month, options)
      end
    end
  end
end
