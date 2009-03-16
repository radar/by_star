module Frozenplague
  module ByStar
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      
      # Pass in the numeric value of the year, either 4 digit or 2 digit. 
      # Examples:
      # Post.by_year(2009)
      # => <Posts for 2009>
      def by_year(value=Time.now.year, opts={}, &block)
        value = work_out_year(value)
        opts[:year] ||= if value == Time || value == Date
          value.year
        end
        start_time = Time.local(value, 1, 1)
        end_time = start_time.end_of_year
        by_star(start_time, end_time, opts, &block)
      end
      
      # Pass in the number of a month, the month name, or a time object to execute a find for that month.
      # Accepts a year option.
      # Examples:
      # Post.by_month(1)
      # => <Posts for January>
      #
      # Post.by_month("January")
      # => <Posts for January>
      #
      # Post.by_month("January", :year => 2008)
      # => <Posts for January 2008>
      #
      # Post.by_month(Time.local(2008,1,16))
      # => <Posts for January 2008>
      #
      #
      # Post.by_month("January", :field => "not_created_at")
      # => <Posts for January 2008, using an alternative field>
      #
      # Post.by_month(1) do
      #   { :include => "tags", :conditions => ["tags.name = ?", "ruby"] }
      # end
      # => <Posts in January with a tag called 'ruby'> 
      def by_month(value=Time.now.month, opts={}, &block)
        opts[:year] ||= Time.now.year
        
        # Work out what actual month is.
        month = if value.class == Fixnum && value >= 1 && value <= 12
          value
        elsif value.class == Time || value.class == Date
          opts[:year] = value.year
          value.month
        elsif value.class == String && Date::MONTHNAMES.include?(value)
          Date::MONTHNAMES.index(value)
        else
          raise ParseError, "Value is not an integer (between 1 and 12), time object or string (make sure you typed the name right)."
        end
        
        # Get the local time of the beginning of the month
        start_time = Time.local(opts[:year], month, 1)
        
        # Cheat a little to get the end of the month
        end_time = start_time.end_of_month

        # And since timestamps in the database are UTC by default, assume noone's changed it.
          by_star(start_time, end_time, opts, &block)
        # end
      end
      
      # Pass in the fortnight. Accepts the year option.
      # Examples:
      # Post.by_fortnight(18)
      # <Posts in the 18th week of the current year>
      #
      # Post.by_night(18, :year => 2004)
      # <Posts in the 18th fortnight of 2004>
      #
      # TODO: Get it to support a Time and Date object.
      def by_fortnight(value, opts={}, &block)
        opts[:year] = !opts[:year].nil? ? work_out_year(opts[:year]) : Time.now.year
        # Dodgy!
        # Surely there's a method in Rails to do this.
        start_time = if value.class == Time || value.class == Date
          (value.strftime("%U").to_i - 1).weeks
          opts[:year] = value.year
        elsif value.to_i.class == Fixnum && value <= 26
          Time.local(opts[:year], 1, 1) + ((value.to_i - 1) * 2).weeks
        else
          raise ParseError, "by_fortnight takes only a Time object, or a Fixnum (less than 27)."
        end
        end_time = start_time + 2.weeks
        
        by_star(start_time, end_time, opts, &block)
      end
      
      # Pass in the week number, or a time object.
      # Examples:
      # Post.by_week(36)
      # <Posts in the 36th week of the current year>
      #
      # Post.by_week(36, :year => 2004)
      # <Posts in the 36th week of 2004>
      #
      # Post.by_week(Time.local(2008, 1, 1))
      # <Posts in the first week of 2008>
      #
      # TODO: Get it to support a Time and Date object.
      def by_week(value, opts={}, &block)
        opts[:year] = !opts[:year].nil? ? work_out_year(opts[:year]) : Time.now.year
        # Dodgy!
        # Surely there's a method in Rails to do this.
        start_time = if value.class == Time || value.class == Date
          (value.strftime("%U").to_i - 1).weeks
          opts[:year] = value.year
        elsif value.to_i.class == Fixnum && value < 52
          Time.local(opts[:year], 1, 1) + (value.to_i - 1).weeks
        else
          raise ParseError, "by_week takes only a Time object, or a Fixnum (less than 52)."
        end
        end_time = start_time + 1.week
        
        by_star(start_time, end_time, opts, &block)
      end
      
      # Pass in a time object.
      # Post.by_day
      # => <Posts for today>
      # Post.by_day(Time.yesterday)
      # => <Posts for yesterday>
      def by_day(value=Time.now.utc, opts={}, &block)
        start_time = value.beginning_of_day.utc
        end_time   = value.end_of_day.utc
        by_star(start_time, end_time, opts, &block)
      end
      
      # Cheating a little more.
      alias_method :today, :by_day
      
    
      private
        # General finder method, takes start time and end time.
        # Excepts field as an option.
        def by_star(start_time, end_time, opts, &block)
          opts[:field] ||= "created_at"
          with_scope(:find => { :conditions => [
                     "#{self.table_name}.#{opts[:field]} >= ? AND
                      #{self.table_name}.#{opts[:field]} <= ?", 
                      start_time.utc, end_time.utc]}) do
                        
            # Is there a cleaner way?
            if block_given?
              with_scope(:find => block.call) do
                find(:all)
              end
            else
              find(:all)
            end
          end
        end
        
        # This will work for the next 30 years (written in 2009)
        def work_out_year(value)
          value = if value < 39
            "20#{value}"
          elsif value > 39 && value <= 99
            "19#{value}"
          else
            value
          end.to_i
        end
    end
    
    class ParseError < Exception; end
    class MonthNotFound < Exception; end
  end
end