module ByStar
  module ByDirection
    def before(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      time = ByStar::Normalization.time(time)
      before_query(time, options)
    end
    alias_method :before_now, :before

    def after(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      time = ByStar::Normalization.time(time)
      after_query(time, options)
    end
    alias_method :after_now, :after
  end
end
