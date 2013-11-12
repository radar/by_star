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

    protected

    def before_String(string, options={})
      if time = Chronic.parse(string)
        before_Time_or_Date(time, options)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end

    def after_String(string, options={})
      if time = Chronic.parse(string)
        after_Time_or_Date(time, options)
      else
        raise ParseError, "Chronic couldn't understand #{string.inspect}. Please try something else."
      end
    end
  end
end
