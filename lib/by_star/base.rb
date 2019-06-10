module ByStar

  module Base

    include ByStar::Between
    include ByStar::Directional

    def by_star_field(*args)
      options = args.extract_options!
      @by_star_start_field ||= args[0]
      @by_star_end_field   ||= args[1]
      @by_star_offset      ||= options[:offset]
      @by_star_scope       ||= options[:scope]
      @by_star_index_scope ||= options[:index_scope]
    end

    def by_star_offset(options = {})
      (options[:offset] || @by_star_offset || 0).seconds
    end

    def by_star_start_field(options={})
      field = options[:field] ||
          options[:start_field] ||
          @by_star_start_field ||
          by_star_default_field
      field.to_s
    end

    def by_star_end_field(options={})
      field = options[:field] ||
          options[:end_field] ||
          @by_star_end_field ||
          by_star_start_field
      field.to_s
    end

    protected

    # Wrapper function which extracts time and options for each by_star query.
    # Note the following syntax examples are valid:
    #
    #   Post.by_month                   # defaults to current time
    #   Post.by_month(2, year: 2004)    # February, 2004
    #   Post.by_month(Time.now)
    #   Post.by_month(Time.now, field: "published_at")
    #   Post.by_month(field: "published_at")
    #
    def with_by_star_options(*args, &block)
      options = args.extract_options!.symbolize_keys!
      time = args.first || Time.zone.now
      block.call(time, options)
    end

    def by_star_eval_index_scope(start_time, end_time, options)
      value = options[:index_scope] || @by_star_index_scope
      value = value.call(start_time, end_time, options) if value.is_a?(Proc)
      case value
        when nil, false then nil
        when Time, DateTime, Date then value.in_time_zone
        when ActiveSupport::Duration then start_time - value
        when Numeric then start_time - value.seconds
        when :beginning_of_day
          offset = options[:offset] || 0
          (start_time - offset).beginning_of_day + offset
        else raise 'ByStar :index_scope option value is not a supported type.'
      end
    end
  end
end
