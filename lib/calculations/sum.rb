module ByStar
  module Calculations
    module Sum
      def sum_by_year(field, year=Time.zone.now.year, options={})
        sum(field, :conditions => conditions_for_range(start_of_year(year), end_of_year(year), options))
      end

      def sum_by_month(field, month=Time.zone.now.month, options={})
        year, month = work_out_month(month, options)
        sum(field, :conditions => conditions_for_range(start_of_month(month, year), end_of_month(month, year), options))
      end
    end
  end
end