module ByStar
  module ByYear

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

    def by_year(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now

      send("by_year_#{time_klass(time)}", time, options)
    end

    private

    def by_year_Time(time, options={})
      between(time.beginning_of_year, time.end_of_year, options)
    end

    def by_year_Date(date, options={})
      by_year_Time(date.to_time, options)
    end

    def by_year_String_or_Fixnum(year, options={})
      by_year_Time("#{work_out_year(year)}-01-01".to_time, options)
    end
    alias_method :by_year_String, :by_year_String_or_Fixnum
    alias_method :by_year_Fixnum, :by_year_String_or_Fixnum

    def work_out_year(value)
      case value.to_i
      when 0..39
        2000 + value
      when 40..99
        1900 + value
      when nil
        Time.zone.now.year
      else
        # We may be passed something that's not a straight out integer
        # These things include: BigDecimals, Floats and Strings.
        value.to_i
      end
    end
  end
end
