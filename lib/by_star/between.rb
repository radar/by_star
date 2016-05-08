module ByStar

  module Between

    def between_times(start, finish, options={})
      offset = by_star_offset(options)
      between_times_query(start + offset, finish + offset, options)
    end

    def by_day(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.time(time)
        between_times(time.beginning_of_day, time.end_of_day, options)
      end
    end

    def by_week(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.week(time, options)
        start_day = Array(options[:start_day])
        between_times(time.beginning_of_week(*start_day), time.end_of_week(*start_day), options)
      end
    end

    def by_cweek(*args)
      with_by_star_options(*args) do |time, options|
        by_week(ByStar::Normalization.cweek(time, options), options)
      end
    end

    def by_weekend(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.week(time, options)
        between_times(time.beginning_of_weekend, time.end_of_weekend, options)
      end
    end

    def by_fortnight(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.fortnight(time, options)
        between_times(time.beginning_of_fortnight, time.end_of_fortnight, options)
      end
    end

    def by_month(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.month(time, options)
        between_times(time.beginning_of_month, time.end_of_month, options)
      end
    end

    def by_calendar_month(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.month(time, options)
        start_day = Array(options[:start_day])
        between_times(time.beginning_of_calendar_month(*start_day), time.end_of_calendar_month(*start_day), options)
      end
    end

    def by_quarter(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.quarter(time, options)
        between_times(time.beginning_of_quarter, time.end_of_quarter, options)
      end
    end

    def by_year(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.year(time, options)
        between_times(time.beginning_of_year, time.end_of_year, options)
      end
    end

    def today(options={})
      by_day(Time.zone.now, options)
    end

    def yesterday(options={})
      by_day(Time.zone.now.yesterday, options)
    end

    def tomorrow(options={})
      by_day(Time.zone.now.tomorrow, options)
    end

    def past_day(options={})
      between_times(Time.zone.now - 1.day, Time.zone.now, options)
    end

    def past_week(options={})
      between_times(Time.zone.now - 1.week, Time.zone.now, options)
    end

    def past_fortnight(options={})
      between_times(Time.zone.now - 2.weeks, Time.zone.now, options)
    end

    def past_month(options={})
      between_times(Time.zone.now - 1.month, Time.zone.now, options)
    end

    def past_year(options={})
      between_times(Time.zone.now - 1.year, Time.zone.now, options)
    end

    def next_day(options={})
      between_times(Time.zone.now, Time.zone.now + 1.day, options)
    end

    def next_week(options={})
      between_times(Time.zone.now, Time.zone.now  + 1.week, options)
    end

    def next_fortnight(options={})
      between_times(Time.zone.now, Time.zone.now + 2.weeks, options)
    end

    def next_month(options={})
      between_times(Time.zone.now, Time.zone.now + 1.month, options)
    end

    def next_year(options={})
      between_times(Time.zone.now, Time.zone.now + 1.year, options)
    end
  end
end
