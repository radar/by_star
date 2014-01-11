module ByStar
  module ByQuarter

    def by_quarter(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.quarter(time, options)
        by_quarter_query(time, options)
      end
    end

    private

    def by_quarter_query(time, options={})
      between(time.beginning_of_quarter, time.end_of_quarter, options)
    end
  end
end
