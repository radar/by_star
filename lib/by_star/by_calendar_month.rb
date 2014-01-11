module ByStar
  module ByCalendarMonth

    def by_calendar_month(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.month(time, options)
        start_day = Array(options[:start_day])
        between(time.beginning_of_calendar_month(*start_day), time.end_of_calendar_month(*start_day), options)
      end
    end
  end
end
