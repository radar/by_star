module ByStar
  module Calculations
    include Count
    include Sum
    
    private
      def work_out_month(time, year=Time.zone.now.year)
        year ||= Time.zone.now.year
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