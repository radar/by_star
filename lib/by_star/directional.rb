module ByStar

  module Directional

    def before(*args)
      with_by_star_options(*args) do |time, options|
        field = by_star_start_field(options)
        time = ByStar::Normalization.time(time)
        by_star_before_query(self, field, time)
      end
    end
    alias_method :before_now, :before

    def after(*args)
      with_by_star_options(*args) do |time, options|
        field = by_star_start_field(options)
        time = ByStar::Normalization.time(time)
        by_star_after_query(self, field, time)
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
