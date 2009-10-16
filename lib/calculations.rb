module ByStar
  module Calculations
    def sum_by_month(field, *args)
      by_month(*args) do
        sum(field)
      end
    end
  end
end