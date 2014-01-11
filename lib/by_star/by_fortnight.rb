module ByStar
  module ByFortnight

    def by_fortnight(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.fortnight(time, options)
        between_times(time.beginning_of_fortnight, time.end_of_fortnight, options)
      end
    end
  end
end
