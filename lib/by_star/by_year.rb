module ByStar
  module ByYear
    def by_year(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now

      send("by_year_#{time_klass(time)}", time, options)
    end

    private

    def by_year_Time(time, options={})
      between(time.beginning_of_year, time.end_of_year)
    end

    def by_year_String_or_Fixnum(year, options={})
      by_year_Time("#{year.to_s}-01-01".to_time, options)
    end
    alias_method :by_year_String, :by_year_String_or_Fixnum
    alias_method :by_year_Fixnum, :by_year_String_or_Fixnum
  end
end
