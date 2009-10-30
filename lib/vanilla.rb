module ByStar
  module Vanilla
    # Examples:
    #   by_year(2010)
    #   # 2-digit year:
    #   by_year(10)
    #   # Time or Date object:
    #   by_year(time)
    #   # String:
    #   by_year("2010")
    def by_year(time=Time.zone.now.year, options={}, &block)
      year = work_out_year(time)
      start_time = start_of_year(year)
      end_time = start_time.end_of_year
      by_star(start_time, end_time, options, &block)
    rescue ArgumentError
      raise ParseError, "Invalid arguments detected, year may possibly be outside of valid range (1902-2039). This is no longer a problem on Ruby versions >= 1.8.7, so we recommend you upgrade to at least 1.8.7."
    end

    # Examples:
    #   by_month(1)
    #   by_month("January")
    #   by_month("January", :year => 2008)
    #   by_month(time)
    def by_month(time=Time.zone.now.month, options={}, &block)
      time = Time.zone.now.month if time.nil?
      year, month = work_out_month(time, options.delete(:year))
  
      start_time = start_of_month(month, year)
      end_time = start_time.end_of_month

      by_star(start_time, end_time, options, &block)
    end

    # Examples:
    #   # 18th fortnight of 2004
    #   Post.by_fortnight(18, :year => 2004)
    def by_fortnight(time=Time.zone.now, options = {}, &block)
      time = parse(time)
  
      # If options[:year] is passed in, use that year regardless.
      year = work_out_year(options[:year]) if options[:year]
      # If the first argument is a date or time, ask it for the year
      year ||= time.year unless time.is_a?(Numeric)
      # If the first argument is a fixnum, assume this year.
      year ||= Time.zone.now.year
  
      # Dodgy!
      # Surely there's a method in Rails to do this.
      start_time = if valid_time_or_date?(time)
        time.beginning_of_year + (time.strftime("%U").to_i).weeks
      elsif time.is_a?(Numeric) && time <= 26
        Time.utc(year, 1, 1) + ((time.to_i) * 2).weeks
      else
        raise ParseError, "by_fortnight takes only a Time or Date object, a Fixnum (less than or equal to 26) or a Chronicable string."
      end
      start_time = start_time.beginning_of_week
      end_time = start_time + 2.weeks
      by_star(start_time, end_time, options, &block)
    end

    # Examples:
    #   # 36th week
    #   Post.by_week(36)
    #   Post.by_week(36.54)
    #   Post.by_week(36, :year => 2004)
    #   Post.by_week(<Time object>)
    #   Post.by_week(<Date object>)
    #   Post.by_week("next tuesday")
    def by_week(time=Time.zone.now, options = {}, &block)
      time = parse(time)
  
      # If options[:year] is passed in, use that year regardless.
      year = work_out_year(options.delete(:year)) if options[:year]
      # If the first argument is a date or time, ask it for the year
      year ||= time.year unless time.is_a?(Numeric)
      # If the first argument is a fixnum, assume this year.
      year ||= Time.now.year
  
      # Dodgy!
      # Surely there's a method in Rails to do this.
      start_time = if valid_time_or_date?(time)
        weeks = time.strftime("%U").to_i
        time.beginning_of_year
      elsif time.is_a?(Numeric) && time < 53
        weeks = time.to_i
        Time.utc(year, 1, 1)
      else
        raise ParseError, "by_week takes only a Time or Date object, a Fixnum (less than or equal to 53) or a Chronicable string."
      end
      start_time += weeks.weeks
      end_time = start_time + 1.week
      by_star(start_time, end_time, options, &block)
    end


    # Examples:
    #    Post.by_weekend
    #    Post.by_weekend(Time.now + 5.days)
    #    Post.by_weekend(Date.today + 5)
    #    Post.by_weekend("next tuesday")
    def by_weekend(time=Time.zone.now, options = {}, &block)
      time = parse(time)
      start_time = time.beginning_of_weekend
      by_star(start_time, (start_time + 1.day).end_of_day, options, &block)
    end


    # Examples:
    # Post.by_current_weekend
    def by_current_weekend(options = {}, &block)
      time = Time.zone.now
      # Friday, 3pm
      start_time = time.beginning_of_weekend
      # Monday, 3am
      end_time = time.end_of_weekend
      by_star(start_time, end_time, options, &block)
    end

    # Examples:
    # Post.by_current_work_week
    def by_current_work_week(options = {}, &block)
      time = Time.zone.now
      # Monday, 3am
      time = time + 1.week if time.wday == 6 || time.wday == 0
      start_time = time.beginning_of_week + 3.hours
      # Friday, 3pm
      end_time = time.beginning_of_weekend
      by_star(start_time, end_time, options, &block)
    end


    # Examples:
    #   Post.by_day
    #   Post.by_day(Time.yesterday)
    #   Post.by_day("next tuesday")
    def by_day(time = Time.zone.now, options = {}, &block)
      time = parse(time)
      by_star(time.beginning_of_day, time.end_of_day, options, &block)
    end
    alias_method :today, :by_day

    # Examples:
    #   Post.yesterday
    #   # 2 days ago:
    #   Post.yesterday(Time.yesterday)
    #   # day before next tuesday
    #   Post.yesterday("next tuesday")
    def yesterday(time = Time.zone.now, options = {}, &block)
      time = parse(time)
      by_day(time.advance(:days => -1), options, &block)
    end

    # Examples:
    #   Post.tomorrow
    #   # 2 days from now:
    #   Post.tomorrow(Time.tomorrow)
    #   # day after next tuesday
    #   Post.tomorrow("next tuesday")
    def tomorrow(time = Time.zone.now, options = {}, &block)
      time = parse(time)
      by_day(time.advance(:days => 1), options, &block)
    end

    # Scopes to records older than current or given time
    # Post.past
    # Post.past()
    def past(time = Time.zone.now, options = {}, &block)
      time = parse(time)
      by_direction("<", time, options, &block)
    end

    # Scopes to records newer than current or given time
    def future(time = Time.zone.now, options = {}, &block)
      time = parse(time)
      by_direction(">", time, options, &block)
    end

    private
      
      def by_direction(condition, time, options = {}, &block)
        field = connection.quote_table_name(table_name)
        field << "." << connection.quote_column_name(options.delete(:field) || "created_at")
        validate_find_options(options)
        scoping = { :conditions => ["#{field} #{condition} ?", time.utc] }.merge(options)
        with_scope(:find => scoping) do
          scoped_by(block) do
            find(:all)
          end
        end
      end
  
      # scopes results between start_time and end_time
      def by_star(start_time, end_time, options = {}, &block)
        start_time = parse(start_time) 
        end_time = parse(end_time)
    
        raise ParseError, "End time is before start time, searching like this will return no results." if end_time < start_time
        field = options.delete(:field)
        validate_find_options(options)
        scoping = { :conditions => conditions_for_range(start_time, end_time, field) }.merge(options)
        with_scope(:find => scoping) do
          scoped_by(block) do
            find(:all)
          end
        end
      end
  
      alias :between :by_star
      public :between
  
      # This will work for the next 30 years (written in 2009)
      def work_out_year(value)
        case value
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
  
      # Checks if the object is a Time, Date or TimeWithZone object.
      def valid_time_or_date?(value)
        value.is_a?(Time) || value.is_a?(Date) || value.is_a?(ActiveSupport::TimeWithZone)
      end
  
      def parse(object)
        object = case object.class.to_s
        when "NilClass"
          o = Time.zone.now
        when "String"
          o = object
          Chronic.parse(object, :now => Time.zone.now)
        when "Date"
          object.to_time(:utc)
        else
          object
        end
        raise ParseError, "Chronic couldn't work out #{o.inspect}; please be more precise." if object.nil?
        object
      end
  
      def method_missing(method, *args)
        if method.to_s =~ /^(as_of|up_to)_(.+)$/
          method = $1
          expr = $2.humanize
          unless time = parse(expr)
            raise ParseError, "Chronic couldn't work out #{expr.inspect}; please be more precise."
          end
      
          reference = args.first || Time.now
      
          if "as_of" == method
            between(time, reference)
          else
            between(reference, time)
          end
        else
          super
        end
    end
  end
end