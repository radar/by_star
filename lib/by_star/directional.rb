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

    def oldest(*args)
      with_by_star_options(*args) do |time, options|
        oldest_query(options)
      end
    end

    def newest(*args)
      with_by_star_options(*args) do |time, options|
        newest_query(options)
      end
    end
  end
end
