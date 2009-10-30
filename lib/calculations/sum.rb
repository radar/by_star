module ByStar
  module Calculations
    module Sum
      def sum_by_year(field, year=Time.zone.now.year, options={}, &block)
        scoped_by(block) do
          sum(field, { :conditions => conditions_for_range(start_of_year(year), end_of_year(year), options.delete(:field)) }.reverse_merge!(options))
        end
      end

      def sum_by_month(field, month=Time.zone.now.month, options={}, &block)
        year, month = work_out_month(month, options.delete(:year))
        scoped_by(block) do
          sum(field, { :conditions => conditions_for_range(start_of_month(month, year), end_of_month(month, year), options.delete(:field)) }.reverse_merge!(options))
        end
      end
    end
  end
end