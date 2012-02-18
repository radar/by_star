module ByStar
  module ByFortnight
    def by_fortnight(time=Time.zone.now.beginning_of_day, options={})
      options.symbolize_keys!
      send("by_fortnight_#{time_klass(time)}", time, options)
    end

    private

    def by_fortnight_Time_or_Date(time, options={})
      # We want to get the current fortnight and so...
      # We need to find the current week number and take one from it,
      # so that we are correctly offset from the start of the year.
      # The first fortnight of the year should of course start on the 1st January,
      # and not the beginning of that week.
      start_time = time.beginning_of_year + (time.strftime("%U").to_i - 1).weeks
      between(start_time, start_time + 2.weeks, options)
    end
    alias_method :by_fortnight_Time, :by_fortnight_Time_or_Date
    alias_method :by_fortnight_Date, :by_fortnight_Time_or_Date

    def by_fortnight_String_or_Fixnum(weeks, options={})
      weeks = weeks.to_i
      current_time = Time.zone.local(options[:year] || Time.zone.now.year)
      if weeks <= 26
        start_time = current_time + (weeks * 2).weeks
        between(start_time, start_time + 2.weeks, options)
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
