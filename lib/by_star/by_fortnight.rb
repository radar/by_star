module ByStar
  module ByFortnight

    def by_fortnight(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.fortnight(time, options)
        by_fortnight_query(time, options)
      end
    end

    private

    def by_fortnight_query(time, options={})
      between(time.beginning_of_fortnight, time.end_of_fortnight, options)
    end
  end
end
