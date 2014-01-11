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
              by_star_field_created_at_field
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

    # NOTE: We would define this as this:
    #
    #  def by_year(time=Time.zone.now, options={})
    #
    # But, there's a potential situation where people want to just pass options.
    # Like this:
    #
    #   Post.by_year(:field => "published_at")
    #
    # And so, we support any number of arguments and just parse them as necessary.
    # By doing it this way, we can support *both* this:
    #
    #   Post.by_year(2012, :field => "published_at")
    #
    # And this:
    #
    #   Post.by_year(:field => "published_at")
    #
    # This is because the time variable is going to be defaulting to the current time.
    def with_by_star_options(*args, &block)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year]) if options[:year]
      time ||= Time.zone.now
      block.call(time, options)
    end
  end
end
