module ByStar
  module ByMonth
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_month(*args)
      options = args.extract_options!
      time = args.first || Time.zone.now
      send("by_month_#{time_klass(time)}", time, false, options)
    end

    def by_calendar_month(*args)
      options = args.extract_options!
      time = args.first || Time.zone.now
      send("by_month_#{time_klass(time)}", time, true, options)
    end

    private

    def by_month_Time(time, is_calendar=false, options={})
      if is_calendar
        between(time.beginning_of_month.beginning_of_week, time.end_of_month.end_of_week, options)
      else
        between(time.beginning_of_month, time.end_of_month, options)
      end
    end

    def by_month_Date(date, is_calendar=false, options={})
      by_month_Time(date.to_time, is_calendar, options)
    end

    def by_month_String_or_Fixnum(month, is_calendar=false, options={})
      begin
        year = options[:year] || Time.zone.now.year
        date = Date.parse("#{year}-#{month}-01").to_time
        by_month_Time(date, is_calendar, options)

      rescue
        raise ParseError, "Month must be a number between 1 and 12 or the full month name (e.g. 'January', 'Feburary', etc.)"
      end
    end

    alias_method :by_month_String, :by_month_String_or_Fixnum
    alias_method :by_month_Fixnum, :by_month_String_or_Fixnum

  end
end
