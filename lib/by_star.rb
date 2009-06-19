require 'chronic'
module ByStar
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    # Examples:
    #   by_year(2010)
    #   # 2-digit year:
    #   by_year(10)
    #   # Time or Date object:
    #   by_year(time)
    def by_year(value=Time.zone.now.year, options={}, &block)
      year = valid_time_or_date?(value) ? value.year : value
      year = work_out_year(year)
      
      start_time = Time.utc(year, 1, 1)
      end_time = start_time.end_of_year
      by_star(start_time, end_time, options)
    rescue ArgumentError
      raise ParseError, "Invalid arguments detected, year may possibly be outside of valid range (1902-2039)"
    end
    
    # Examples:
    #   by_month(1)
    #   by_month("January")
    #   by_month("January", :year => 2008)
    #   by_month(time)
    def by_month(value=Time.zone.now.month, options={}, &block)
      year = options[:year] ||= Time.zone.now.year
      # Work out what actual month is.
      month = if value.class == Fixnum && value >= 1 && value <= 12
        value
      elsif valid_time_or_date?(value )
        year = value.year
        value.month
      elsif value.class == String && Date::MONTHNAMES.include?(value)
        Date::MONTHNAMES.index(value)
      else
        raise ParseError, "Value is not an integer (between 1 and 12), time object or string (make sure you typed the name right)."
      end
      
      start_time = Time.utc(year, month, 1)
      end_time = start_time.end_of_month

      by_star(start_time, end_time, options)
    end
    
    # Examples:
    #   # 18th fortnight of 2004
    #   Post.by_fortnight(18, :year => 2004)
    def by_fortnight(value=Time.zone.now, options = {}, &block)
      year = work_out_year(options[:year] || Time.zone.now.year)
      # Dodgy!
      # Surely there's a method in Rails to do this.
      start_time = if valid_time_or_date?(value)
        Time.zone.now.beginning_of_year + (value.strftime("%U").to_i - 1).weeks
      elsif value.to_i.class == Fixnum && value <= 26
        Time.utc(year, 1, 1) + ((value.to_i - 1) * 2).weeks
      else
        raise ParseError, "by_fortnight takes only a Time or Date object, or a Fixnum (less than or equal to 26)."
      end
      end_time = start_time + 2.weeks
      
      by_star(start_time, end_time, options)
    end
    
    # Examples:
    #   # 36th week
    #   Post.by_week(36)
    #   Post.by_week(36, :year => 2004)
    #   Post.by_week(time)
    def by_week(value=Time.zone.now, options = {}, &block)
      year = work_out_year(options[:year] || Time.now.year)
      # Dodgy!
      # Surely there's a method in Rails to do this.
      start_time = if valid_time_or_date?(value)
        Time.zone.now.beginning_of_year + (value.strftime("%U").to_i - 1).weeks
      elsif value.to_i.class == Fixnum && value < 53
        Time.utc(year, 1, 1) + (value.to_i - 1).weeks
      else
        raise ParseError, "by_week takes only a Time or Date object, or a Fixnum (less than or equal to 53)."
      end
      end_time = start_time + 1.week
      by_star(start_time, end_time, options, &block)
    end
    
    
    # Examples:
    # Post.by_weekend(Date.today)
    def by_weekend(value=Time.zone.now, options = {}, &block)
      now = Time.zone.now
      start_time = case value.wday
      when 0
        now.advance(:days => -1) 
      when 6
        now
      else
        now.beginning_of_week.advance(:days => 5)
      end
      by_star(start_time, (start_time + 1.day).end_of_day)
    end
    
    # Examples:
    #   Post.by_day
    #   Post.by_day(Time.yesterday)
    def by_day(time = Time.zone.now, options = {}, &block)
      time = time.to_time(:utc) if time.is_a?(Date)
      by_star(time.beginning_of_day, time.end_of_day, options, &block)
    end
    alias_method :today, :by_day
    
    # Examples:
    #   Post.yesterday
    #   # 2 days ago:
    #   Post.yesterday(Time.yesterday)
    def yesterday(time = Time.zone.now, options = {}, &block)
      by_day(time.advance(:days => -1), options, &block)
    end
    
    # Examples:
    #   Post.tomorrow
    #   # 2 days from now:
    #   Post.tomorrow(Time.tomorrow)
    def tomorrow(time = Time.zone.now, options = {}, &block)
      by_day(time.advance(:days => 1), options, &block)
    end
    
    # Scopes to records older than current or given time
    def past(time = Time.now, options = {}, &block)
      by_direction("<", time, options, &block)
    end
    
    # Scopes to records newer than current or given time
    def future(time = Time.now, options = {}, &block)
      by_direction(">", time, options, &block)
    end
    
    private
    
      def by_direction(condition, time, options = {}, &block)
        field = connection.quote_table_name(table_name)
        field << "." << connection.quote_column_name(options[:field] || "created_at")
        with_scope(:find => { :conditions => ["#{field} #{condition} ?", time.utc] }) do
          if block_given?
            with_scope(:find => block.call) do
              find(:all)
            end
          else
            find(:all)
          end
        end
      end
      
      # scopes results between start_time and end_time
      def by_star(start_time, end_time, options = {})
        field = options[:field] || "created_at"
        with_scope(:find => { :conditions => { field => start_time.utc..end_time.utc } }) do
          if block_given?
            with_scope(:find => block.call) do
              find(:all)
            end
          else
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
        else
          value
        end
      end
      
      # Checks if the object is a Time, Date or TimeWithZone object.
      def valid_time_or_date?(value)
        value.is_a?(Time) || value.is_a?(Date) || value.is_a?(ActiveSupport::TimeWithZone)
      end
      
      def method_missing(method, *args)
        if method.to_s =~ /^(as_of|up_to)_(.+)$/
          method = $1
          expr = $2.humanize
          unless time = Chronic.parse(expr)
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
  
  class ParseError < Exception; end
  class MonthNotFound < Exception; end
end