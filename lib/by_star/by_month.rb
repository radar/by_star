module ByStar
  module ByMonth
    def by_month(*args)
      options = args.extract_options!
      time = args.first

      between(Time.now.beginning_of_month, Time.now.end_of_month)
    end
  end
end
