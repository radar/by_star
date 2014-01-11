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

      # We want to get the current fortnight and so...
      # We need to find the current week number and take one from it,
      # so that we are correctly offset from the start of the year.
      # The first fortnight of the year should of course start on the 1st January,
      # and not the beginning of that week.
      between(time, (time + 2.weeks).end_of_day, options)
    end
  end
end
