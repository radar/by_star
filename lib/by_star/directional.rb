module ByStar

  module Directional

    def before(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.time(time)
        before_query(time, options)
      end
    end
    alias_method :before_now, :before

    def after(*args)
      with_by_star_options(*args) do |time, options|
        time = ByStar::Normalization.time(time)
        after_query(time, options)
      end
    end
    alias_method :after_now, :after
  end
end
