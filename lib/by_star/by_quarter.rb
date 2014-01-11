module ByStar
  module ByQuarter
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_quarter(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year]) if options[:year]
      time ||= Time.zone.now
      time = ByStar::Normalization.quarter(time, options)
      by_quarter_query(time, options)
    end

    private

    def by_quarter_query(time, options={})
      between(time.beginning_of_quarter, time.end_of_quarter, options)
    end
  end
end
