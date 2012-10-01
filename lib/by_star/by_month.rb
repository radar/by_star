module ByStar
  module ByMonth
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_month(*args)
      options = args.extract_options!
      time = args.first || Time.zone.now
      send("by_month_#{time_klass(time)}", time, options)
    end

    private

    def by_month_Time(time, options={})
      between(time.beginning_of_month, time.end_of_month, options)
    end

    def by_month_String_or_Fixnum(month, options={})
      if valid_month?(month)
        year = options[:year] || Time.zone.now.year
        by_month_Time("#{year}-#{month}-01".to_time(:local), options)
      else
        raise ParseError, "Month must be a number between 1 and 12 or the full month name (e.g. 'January', 'Feburary', etc.)"
      end
    end
    alias_method :by_month_String, :by_month_String_or_Fixnum
    alias_method :by_month_Fixnum, :by_month_String_or_Fixnum


    def valid_month?(month)
      (1..12).include?(month) || Date::MONTHNAMES.include?(month)
    end

  end
end
