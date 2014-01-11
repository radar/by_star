module ByStar
  module ByYear

    # NOTE: We would define this as this:
    #
    #  def by_year(time=Time.zone.now, options={})
    #
    # But, there's a potential situation where people want to just pass options.
    # Like this:
    #
    #   Post.by_year(:field => "published_at")
    #
    # And so, we support any number of arguments and just parse them as necessary.
    # By doing it this way, we can support *both* this:
    #
    #   Post.by_year(2012, :field => "published_at")
    #
    # And this:
    #
    #   Post.by_year(:field => "published_at")
    #
    # This is because the time variable is going to be defaulting to the current time.

    def by_year(*args)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      time = ByStar::Normalization.year(time, options)
      by_year_query(time, options)
    end

    def by_year_query(time, options={})
      between(time.beginning_of_year, time.end_of_year, options)
    end
  end
end
