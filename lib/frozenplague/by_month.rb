module Frozenplague
  module ByMonth
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      # Pass in the number of a month, the month name, or a time object to execute a find for that month.
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
      
      def by_month(value, opts={}, &block)
        opts[:year] ||= Time.now.year
        opts[:field] ||= "created_at"
        if value.class == Fixnum
          month = value
        elsif value.class == Time
          month = value.month
          opts[:year] = value.year
        elsif value.class == String
          month = Date::MONTHNAMES.index(value)
        else
          raise ParseError, "Value is not an integer, time object or string."
        end
        raise MonthNotFound, "Could not find a month with the value you specified." if month.nil?
        
        # Get the local time of the beginning of the month
        beginning_of_month = Time.local(opts[:year], month, 1)
        
        # Cheat a little to get the end of the month
        end_of_month = beginning_of_month.end_of_month

        # And since timestamps in the database are UTC by default, assume noone's changed it.
        # with_scope rules!
        with_scope(:find => { :conditions => ["#{self.table_name}.#{opts[:field]} >= ? AND #{self.table_name}.#{opts[:field]} <= ?", beginning_of_month.utc, end_of_month.utc]}) do
          if block_given?
            with_scope(:find => block.call) do
              find(:all)
            end
          else
            find(:all)
          end
        end
      end
    end
    
    class ParseError < Exception; end
    class MonthNotFound < Exception; end
  end
end