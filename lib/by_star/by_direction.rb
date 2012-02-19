module ByStar
  module ByDirection
    def before(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      send("before_#{time_klass(time)}", time, options)
    end
    alias_method :before_now, :before

    def after(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      send("after_#{time_klass(time)}", time, options)
    end
    alias_method :after_now, :after

    private

    def before_Time_or_Date(time_or_date, options={})
      field = options[:field] || by_star_field
      where("#{field} <= ?", time_or_date)
    end
    alias_method :before_Time, :before_Time_or_Date
    alias_method :before_Date, :before_Time_or_Date

    def before_String(string, options={})
      field = options[:field] || by_star_field
      if time = Chronic.parse(string)
        where("#{field} <= ?", time)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end

    def after_Time_or_Date(time_or_date, options={})
      field = options[:field] || by_star_field
      where("#{field} >= ?", time_or_date)
    end
    alias_method :after_Time, :after_Time_or_Date
    alias_method :after_Date, :after_Time_or_Date

    def after_String(string, options={})
      field = options[:field] || by_star_field
      if time = Chronic.parse(string)
        where("#{field} >= ?", time)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end

  end
end
