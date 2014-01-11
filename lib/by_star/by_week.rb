module ByStar
  module ByWeek

    def by_week(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.week(time, options)
        start_day = Array(options[:start_day])
        between_times(time.beginning_of_week(*start_day), time.end_of_week(*start_day), options)
      end
    end
  end
end
