module ByStar
  module Calculations
    def sum_by_year(field, year=Time.now.year, options={})
      sum(field, :conditions => conditions_for_range(start_of_year(year), end_of_year(year), options))
    end
    
    def sum_by_month(field, month=Time.now.month, options={})
      year, month = work_out_month(month, options)
      sum(field, :conditions => conditions_for_range(start_of_month(month, year), end_of_month(month, year), options))
    end
    
    private
      def work_out_month(time, options = {})
        year = options[:year] ||= Time.zone.now.year
        # Work out what actual month is.
        month = if time.is_a?(Numeric) && (1..12).include?(time)
          time
        elsif valid_time_or_date?(time)
          year = time.year
          time.month
        elsif time.is_a?(String) && Date::MONTHNAMES.include?(time)
          Date::MONTHNAMES.index(time)
        else
          raise ParseError, "Value is not an integer (between 1 and 12), time object or string (make sure you typed the name right)."
        end
        [year, month]
      end
  end
end