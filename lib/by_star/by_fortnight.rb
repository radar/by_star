module ByStar
  module ByFortnight
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_fortnight(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      time = ByStar::Normalization.fortnight(time, options)
      by_fortnight_query(time, options)
    end

    private

    def by_fortnight_query(time, options={})
      # We want to get the current fortnight and so...
      # We need to find the current week number and take one from it,
      # so that we are correctly offset from the start of the year.
      # The first fortnight of the year should of course start on the 1st January,
      # and not the beginning of that week.
      start_time = time.beginning_of_year + (time.strftime("%U").to_i - 1).weeks
      between(start_time, (start_time + 2.weeks).end_of_day, options)
    end
  end
end
