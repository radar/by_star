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

    def by_star_scope(options={})
      scope = options[:scope] || @by_star_scope || self
      if scope.is_a?(Proc)
        if scope.arity == 0
          return instance_exec(&scope)
        elsif options[:scope_args]
          return instance_exec(*Array(options[:scope_args]), &scope)
        else
          raise 'ByStar :scope Proc requires :scope_args to be specified.'
        end
      else
        return scope
      end
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
  end
end
