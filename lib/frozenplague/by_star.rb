require 'chronic'

module Frozenplague
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
      def by_year(value = Time.now.year, options = {})
        year = (Time === value or Date === value) ? value.year : value
        year = work_out_year(year)
        
        start_time = Time.utc(year, 1, 1)
        end_time = start_time.end_of_year
        by_star(start_time, end_time, options)
      end
      
      # Examples:
      #   by_month(1)
      #   by_month("January")
      #   by_month("January", :year => 2008)
      #   by_month(time)
      def by_month(value = Time.now.month, options = {})
        year = options[:year] || Time.now.year
        
        # Work out what actual month is.
        month = if value.class == Fixnum && value >= 1 && value <= 12
          value
        elsif value.class == Time || value.class == Date
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
      #   # 18th week of 2004
      #   Post.by_fortnight(18, :year => 2004)
      def by_fortnight(value, options = {})
        year = work_out_year(options[:year] || Time.now.year)
        # Dodgy!
        # Surely there's a method in Rails to do this.
        start_time = if value.class == Time || value.class == Date
          (value.strftime("%U").to_i - 1).weeks
          year = value.year
        elsif value.to_i.class == Fixnum && value <= 26
          Time.utc(year, 1, 1) + ((value.to_i - 1) * 2).weeks
        else
          raise ParseError, "by_fortnight takes only a Time object, or a Fixnum (less than 27)."
        end
        end_time = start_time + 2.weeks
        
        by_star(start_time, end_time, options)
      end
      
      # Examples:
      #   # 36th week
      #   Post.by_week(36)
      #   Post.by_week(36, :year => 2004)
      #   Post.by_week(time)
      def by_week(value, options = {})
        year = work_out_year(options[:year] || Time.now.year)
        # Dodgy!
        # Surely there's a method in Rails to do this.
        start_time = if value.class == Time || value.class == Date
          (value.strftime("%U").to_i - 1).weeks
          year = value.year
        elsif value.to_i.class == Fixnum && value < 52
          Time.utc(year, 1, 1) + (value.to_i - 1).weeks
        else
          raise ParseError, "by_week takes only a Time object, or a Fixnum (less than 52)."
        end
        end_time = start_time + 1.week
        
        by_star(start_time, end_time, options)
      end
      
      # Examples:
      #   Post.by_day
      #   Post.by_day(Time.yesterday)
      def by_day(time = Time.now, options = {})
        by_star(time.beginning_of_day, time.end_of_day, options)
      end
      alias_method :today, :by_day
      
      # Examples:
      #   Post.yesterday
      #   # 2 days ago:
      #   Post.yesterday(Time.yesterday)
      def yesterday(time = Time.now, options = {})
        by_day(time.advance(:days => -1), options)
      end
      
      # Examples:
      #   Post.tomorrow
      #   # 2 days from now:
      #   Post.tomorrow(Time.tomorrow)
      def tomorrow(time = Time.now, options = {})
        by_day(time.advance(:days => 1), options)
      end
      
      # Scopes to records older than current or given time
      def past(time = Time.now, options = {})
        by_direction("<", time, options)
      end
      
      # Scopes to records newer than current or given time
      def future(time = Time.now, options = {})
        by_direction(">", time, options)
      end
      
      private
      
        def by_direction(condition, time, options = {})
          field = connection.quote_table_name(table_name)
          field << "." << connection.quote_column_name(options[:field] || "created_at")
          scoped :conditions => ["#{field} #{condition} ?", time.utc]
        end
        
        # scopes results between start_time and end_time
        def by_star(start_time, end_time, options = {})
          field = options[:field] || "created_at"
          scoped :conditions => { field => start_time.utc..end_time.utc }
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
        
        def method_missing(method, *args)
          if method.to_s =~ /^(as_of|up_to)_(.+)$/
            method = $1
            expr = $2.humanize
            unless time = Chronic.parse(expr)
              raise ParseError, "Chronic couldn't work out #{expr.inspect}; please be more precise"
            end
            
            if "as_of" == method
              between(time, Time.now.utc)
            else
              between(Time.now.utc, time)
            end
          else
            super
          end
        end
    end
    
    class ParseError < Exception; end
    class MonthNotFound < Exception; end
  end
end