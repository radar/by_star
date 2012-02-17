module ByStar
  module ByYear
    def by_year(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      klass = case time
        when ActiveSupport::TimeWithZone
          Time
        else
          time.class
        end

      send("by_year_#{klass}", time, options)
    end

    private

    def by_year_Time(time, options={})
      field = options[:field] || by_star_field
      scope = where("#{field} >= ? AND #{field} <= ?",
                time.beginning_of_year, time.end_of_year)
      scope = scope.order(options[:order]) if options[:order]
      scope
    end

    def by_year_String_or_Fixnum(year, options={})
      time = "#{year.to_s}-01-01 00:00:00".to_time
      by_year_Time(time, options)
    end
    alias_method :by_year_String, :by_year_String_or_Fixnum
    alias_method :by_year_Fixnum, :by_year_String_or_Fixnum
  end
end
