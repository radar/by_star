module ByStar
  module ByWeekend

    def by_weekend(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.week(time, options)
        between_times(time.beginning_of_weekend, time.end_of_weekend, options)
      end
    end
  end
end
