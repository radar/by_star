module ByStar
  module ByMonth

    def by_month(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.month(time, options)
        between(time.beginning_of_month, time.end_of_month, options)
      end
    end
  end
end
