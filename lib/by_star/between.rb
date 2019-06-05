module ByStar

  module Between

    def between_times(*args)
      options = args.extract_options!.symbolize_keys!

      start_time, end_time = case args[0]
                               when Array, Range then [args[0].first, args[0].last]
                               else args[0..1]
                             end

      offset = options[:offset] || 0
      if start_time.is_a?(Date) || end_time.is_a?(Date)
        start_time = ByStar::Normalization.offset_changed_start(start_time.in_time_zone, offset) if start_time
        end_time = ByStar::Normalization.offset_changed_end(end_time.in_time_zone, offset) if end_time
      else
        start_time += offset.seconds if start_time
        end_time   += offset.seconds if end_time
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
        time = ByStar::Normalization.time(time)
        with_offset_change(time, time, (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
      end
    end

    def by_week(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.week(time, options)
        start_day = Array(options[:start_day])
        with_offset_change(
          time.beginning_of_week(*start_day),
          time.end_of_week(*start_day),
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
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
        with_offset_change(
          time.beginning_of_weekend,
          time.end_of_weekend,
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
      end
    end

    def by_fortnight(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.fortnight(time, options)
        with_offset_change(
          time.beginning_of_fortnight,
          time.end_of_fortnight,
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
      end
    end

    def by_month(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.month(time, options)
        with_offset_change(
          time.beginning_of_month,
          time.end_of_month,
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
      end
    end

    def by_calendar_month(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.month(time, options)
        start_day = Array(options[:start_day])
        with_offset_change(
          time.beginning_of_calendar_month(*start_day),
          time.end_of_calendar_month(*start_day),
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
      end
    end

    def by_quarter(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.quarter(time, options)
        with_offset_change(
          time.beginning_of_quarter,
          time.end_of_quarter,
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
      end
    end

    def by_year(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.year(time, options)
        with_offset_change(
          time.beginning_of_year,
          time.end_of_year,
          (options.delete(:offset) || 0)) do |start_time, end_time|
          between_times(start_time, end_time, options)
        end
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
