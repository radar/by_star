module ByStar
  module ByFortnight
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_fortnight(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      send("by_fortnight_#{time_klass(time)}", time, options)
    end

    private

    def by_fortnight_Time(time, options={})
      # We want to get the current fortnight and so...
      # We need to find the current week number and take one from it,
      # so that we are correctly offset from the start of the year.
      # The first fortnight of the year should of course start on the 1st January,
      # and not the beginning of that week.
      start_time = time.beginning_of_year + (time.strftime("%U").to_i - 1).weeks
      between(start_time, (start_time + 2.weeks).end_of_day, options)
    end

    def by_fortnight_Date(date, options={})
      by_fortnight_Time(date.to_time, options)
    end

    def by_fortnight_String_or_Fixnum(weeks, options={})
      weeks = weeks.to_i
      current_time = Time.zone.local(options[:year] || Time.zone.now.year)
      if weeks <= 26
        start_time = current_time + (weeks * 2).weeks
        between(start_time, (start_time + 2.weeks).end_of_day, options)
      else
        raise ParseError, "by_fortnight takes only a Time, Date or a Fixnum (less than or equal to 26)."
      end
    end
    alias_method :by_fortnight_String, :by_fortnight_String_or_Fixnum
    alias_method :by_fortnight_Fixnum, :by_fortnight_String_or_Fixnum



    # def omg 
    #   time.beginning_of_year + (time.strftime("%U").to_i).weeks
    #   if time.is_a?(Numeric) && time <= 26
    #     Time.utc(year, 1, 1) + ((time.to_i) * 2).weeks
    #   else
    #     raise ParseError, "by_fortnight takes only a Time or Date object, a Fixnum (less than or equal to 26) or a Chronicable string."
    #   end

    #   between(start_time.beginning_of_week, start_time + 2.weeks)
    # end


  end
end
