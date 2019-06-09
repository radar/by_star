module ByStar

  module Between

    def between_times(*args)
      options = args.extract_options!.symbolize_keys!

      start_time, end_time = ByStar::Normalization.extract_range(args)
      offset = options[:offset] || 0

      if start_time.is_a?(Date)
        start_time = ByStar::Normalization.apply_offset_start(start_time.in_time_zone, offset)
      elsif start_time
        start_time += offset.seconds
      end

      if end_time.is_a?(Date)
        end_time = ByStar::Normalization.apply_offset_end(end_time.in_time_zone, offset)
      elsif end_time
        end_time += offset.seconds
      end

      start_field = by_star_start_field(options)
      end_field = by_star_end_field(options)

      scope = self
      scope = if !start_time && !end_time
                scope # do nothing
              elsif !end_time
                by_star_after_query(scope, start_field, start_time)
              elsif !start_time
                by_star_before_query(scope, start_field, end_time)
              elsif start_field == end_field
                by_star_point_query(scope, start_field, start_time, end_time)
              elsif options[:strict]
                by_star_span_strict_query(scope, start_field, end_field, start_time, end_time)
              else
                by_star_span_loose_query(scope, start_field, end_field, start_time, end_time, options)
              end

      scope = by_star_order(scope, options[:order]) if options[:order]
      scope
    end

    def between_dates(*args)
      options = args.extract_options!
      start_date, end_date = ByStar::Normalization.extract_range(args)
      start_date = ByStar::Normalization.date(start_date)
      end_date   = ByStar::Normalization.date(end_date)
      between_times(start_date, end_date, options)
    end

    def at_time(*args)
      with_by_star_options(*args) do |time, options|
        start_field = by_star_start_field(options)
        end_field = by_star_end_field(options)

        scope = self
        scope = if start_field == end_field
                  by_star_point_overlap_query(scope, start_field, time)
                else
                  by_star_span_overlap_query(scope, start_field, end_field, time, options)
                end
        scope = by_star_order(scope, options[:order]) if options[:order]
        scope
      end
    end

    def by_day(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.date(time)
        between_dates(date, date, options)
      end
    end

    def by_week(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.week(time, options)
        start_day = Array(options[:start_day])
        between_dates(date.beginning_of_week(*start_day), date.end_of_week(*start_day), options)
      end
    end

    def by_cweek(*args)
      with_by_star_options(*args) do |time, options|
        by_week(ByStar::Normalization.cweek(time, options), options)
      end
    end

    def by_weekend(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.week(time, options)
        between_dates(date.beginning_of_weekend, date.end_of_weekend, options)
      end
    end

    def by_fortnight(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.fortnight(time, options)
        between_dates(date.beginning_of_fortnight, date.end_of_fortnight, options)
      end
    end

    def by_month(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.month(time, options)
        between_dates(date.beginning_of_month, date.end_of_month, options)
      end
    end

    def by_calendar_month(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.month(time, options)
        start_day = Array(options[:start_day])
        between_dates(date.beginning_of_calendar_month(*start_day), date.end_of_calendar_month(*start_day), options)
      end
    end

    def by_quarter(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.quarter(time, options)
        between_dates(date.beginning_of_quarter, date.end_of_quarter, options)
      end
    end

    def by_year(*args)
      with_by_star_options(*args) do |time, options|
        date = ByStar::Normalization.year(time, options)
        between_dates(date.beginning_of_year, date.to_date.end_of_year, options)
      end
    end

    def today(options = {})
      by_day(Date.current, options)
    end

    def yesterday(options = {})
      by_day(Date.yesterday, options)
    end

    def tomorrow(options = {})
      by_day(Date.tomorrow, options)
    end

    def past_day(options = {})
      between_times(Time.current - 1.day, Time.current, options)
    end

    def past_week(options = {})
      between_times(Time.current - 1.week, Time.current, options)
    end

    def past_fortnight(options = {})
      between_times(Time.current - 2.weeks, Time.current, options)
    end

    def past_month(options = {})
      between_times(Time.current - 1.month, Time.current, options)
    end

    def past_year(options = {})
      between_times(Time.current - 1.year, Time.current, options)
    end

    def next_day(options = {})
      between_times(Time.current, Time.current + 1.day, options)
    end

    def next_week(options = {})
      between_times(Time.current, Time.current  + 1.week, options)
    end

    def next_fortnight(options = {})
      between_times(Time.current, Time.current + 2.weeks, options)
    end

    def next_month(options = {})
      between_times(Time.current, Time.current + 1.month, options)
    end

    def next_year(options = {})
      between_times(Time.current, Time.current + 1.year, options)
    end
  end
end
