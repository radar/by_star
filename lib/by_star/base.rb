module ByStar

  module Base
    include ByStar::ByDirection
    include ByStar::ByYear
    include ByStar::ByMonth
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
  end
end
