module ByStar
  module ByYear

    def by_year(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.year(time, options)
        by_year_query(time, options)
      end
    end

    def by_year_query(time, options={})
      between(time.beginning_of_year, time.end_of_year, options)
    end
  end
end
