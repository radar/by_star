module ByStar

  module Base
    include ByStar::ByDirection
    include ByStar::ByYear
    include ByStar::ByMonth
    include ByStar::ByCalendarMonth
    include ByStar::ByFortnight
    include ByStar::ByWeek
    include ByStar::ByWeekend
    include ByStar::ByDay
    include ByStar::ByQuarter

    def by_star_field(start_field = nil, end_field = nil)
      @by_star_start_field ||= start_field
      @by_star_end_field   ||= end_field
    end

    def by_star_start_field(options={})
      field = options[:start_field] ||
              options[:field] ||
              @by_star_start_field ||
              by_star_default_field
      field.to_s
    end

    def by_star_end_field(options={})
      field = options[:end_field] ||
              options[:field] ||
              @by_star_end_field ||
              by_star_start_field
      field.to_s
    end

    protected

    # Wrapper function which extracts time and options for each by_star query.
    # Note the following syntax examples are valid:
    #
    #   Post.by_month                      # defaults to current time
    #   Post.by_month(2, :year => 2004)    # February, 2004
    #   Post.by_month(Time.now)
    #   Post.by_month(Time.now, :field => "published_at")
    #   Post.by_month(:field => "published_at")
    #
    def with_by_star_options(*args, &block)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year]) if options[:year]
      time ||= Time.zone.now
      block.call(time, options)
    end
  end
end
