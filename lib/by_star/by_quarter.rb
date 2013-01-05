module ByStar
  module ByQuarter
    # For reasoning why I use *args rather than variables here,
    # please see the by_year method comments in lib/by_star/by_year.rb

    def by_quarter(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first
      time ||= Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      send("by_quarter_#{time_klass(time)}", time, options)
    end

    private

    def by_quarter_Time(time, options={})
      between(time.beginning_of_quarter, time.end_of_quarter, options)
    end

    def by_quarter_Date(date, options={})
      by_quarter_Time(date.to_time, options)
    end

    def by_quarter_Fixnum(quarter, options={})
      raise 'Quarter must be a number between 1 and 4' unless quarter >= 1 && quarter <= 4
      time = Time.zone.local(options[:year], 1, 1) if options[:year]
      time ||= Time.zone.now
      start_time = time.beginning_of_year + ((quarter.to_i - 1) * 3).months
      between(start_time, start_time.end_of_quarter, options)
    end
  end
end
