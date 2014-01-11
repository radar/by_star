module ByStar

  class ParseError < StandardError; end

  module Normalization

    class << self

      def time(value)
        case value
          when String then time_string(value)
          when Date, DateTime then value.to_time
          else value
        end
      end

      def time_string(value)
        if defined?(Chronic)
          time = Chronic.parse(value)
          raise ByStar::ParseError, "Chronic could not parse #{value.inspect}" unless time
          time
        else
          Time.parse(value)
        end
      end

      def week(value, options={})
        value = try_string_to_int(value)
        case value
          when Fixnum then week_fixnum(value, options)
          else time(value)
        end
      end

      def week_fixnum(value, options={})
        time = Time.zone.local(options[:year], 1, 1) if options[:year]
        time ||= Time.zone.now
        time.beginning_of_year + value.to_i.weeks
      end

      def fortnight(value, options={})
        value = try_string_to_int(value)
        case value
          when Fixnum then fortnight_fixnum(value, options)
          else time(value)
        end
      end

      def fortnight_fixnum(value, options={})
        raise ParseError, 'Fortnight number must be between 0 and 26' unless value.in?(0..26)
        current_time = Time.zone.local(options[:year] || Time.zone.now.year)
        current_time + (value * 2).weeks
      end

      def quarter(value, options={})
        value = try_string_to_int(value)
        case value
          when Fixnum then quarter_fixnum(value)
          else time(value)
        end
      end

      def quarter_fixnum(value, options={})
        raise ParseError, 'Quarter number must be between 1 and 4' unless value.in?(1..4)
        time = Time.zone.local(options[:year], 1, 1) if options[:year]
        time ||= Time.zone.now
        time.beginning_of_year + ((value - 1) * 3).months
      end

      def month(value, options={})
        case value
          when Fixnum, String then month_fixnum(value, options)
          else time(value)
        end
      end

      def month_fixnum(value, options={})
        year = options[:year] || Time.zone.now.year
        Date.parse("#{year}-#{value}-01").to_time
      rescue
        raise ParseError, "Month must be a number between 1 and 12 or the full month name (e.g. 'January')"
      end

      def year(value, options={})
        value = try_string_to_int(value)
        case value
          when Fixnum then year_fixnum(value)
          else time(value)
        end
      end

      def year_fixnum(value)
        "#{extrapolate_year(value)}-01-01".to_time
      end

      def extrapolate_year(value)
        case value.to_i
          when 0..39
            2000 + value
          when 40..99
            1900 + value
          else
            value.to_i
        end
      end

      def try_string_to_int(value)
        value.is_a?(String) ? Integer(value) : value
      rescue
        value
      end
    end
  end
end
