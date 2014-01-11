module ByStar
  module ByWeekend

    def by_weekend(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.week(time, options)
        by_weekend_query(time, options)
      end
    end

    private

    def by_weekend_query(time, options={})
      between(time.beginning_of_weekend, time.end_of_weekend)
    end
  end
end
