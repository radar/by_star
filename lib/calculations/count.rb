module ByStar
  module Calculations
    module Count
      def count_by_year(field=nil, year=Time.now.year, options={}, &block)
        db_field = options.delete(:field)
        scoped_by(block) do
          count(field, { :conditions => conditions_for_range(start_of_year(year), end_of_year(year), db_field) }.reverse_merge!(options))
        end
      end
      
      def count_by_month(field=nil, month=Time.now.month, options={}, &block)
        db_field = options.delete(:field)
        year, month = work_out_month(month, options.delete(:year))
        scoped_by(block) do
          count(field, { :conditions => conditions_for_range(start_of_month(month, year), end_of_month(month, year), db_field) }.reverse_merge!(options))
        end
      end
    end
  end
end