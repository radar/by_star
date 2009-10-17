module ByStar
  module Calculations
    module Count
      def count_by_year(field=nil, year=Time.now.year, options={})
        count(field, :conditions => conditions_for_range(start_of_year(year), end_of_year(year), options))
      end
      
      def count_by_month(field=nil, month=Time.now.month, options={})
        year, month = work_out_month(month, options)
        count(field, :conditions => conditions_for_range(start_of_month(month, year), end_of_month(month, year), options))
      end
    end
    
  end
end