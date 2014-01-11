module ByStar
  module ByQuarter

    def by_quarter(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.quarter(time, options)
        between_times(time.beginning_of_quarter, time.end_of_quarter, options)
      end
    end
  end
end
