module ByStar

  class ParseError < StandardError; end

  module Normalization

    class << self

      def date(value)
        time(value).to_date
      end

      def time(value)
        case value
          when String   then time_string(value)
          when DateTime then value.to_time
          when Date     then value.in_time_zone
          else value
        end
      end

      def time_string(value)
        defined?(Chronic) ? time_string_chronic(value) : time_string_fallback(value)
      end

      def time_string_chronic(value)
        Chronic.time_class = Time.zone
        Chronic.parse(value) || raise(ByStar::ParseError, "Chronic could not parse String #{value.inspect}")
      end

      def time_string_fallback(value)
        Time.zone.parse(value) || raise(ByStar::ParseError, "Cannot parse String #{value.inspect}")
      end

      def week(value, options={})
        value = try_string_to_int(value)
        case value
          when Integer then week_integer(value, options)
          else date(value)
        end
      end

      def week_integer(value, options={})
        raise ParseError, 'Week number must be between 0 and 52' unless value.in?(0..52)
        time = Time.zone.local(options[:year] || Time.zone.now.year)
        time.beginning_of_year + value.to_i.weeks
      end

      def cweek(value, options={})
        _value = value
        if _value.is_a?(Integer)
          raise ParseError, 'cweek number must be between 1 and 53' unless value.in?(1..53)
          _value -= 1
        end
        week(_value, options)
      end

      def fortnight(value, options={})
        value = try_string_to_int(value)
        case value
          when Integer then fortnight_integer(value, options)
          else date(value)
        end
      end

      def fortnight_integer(value, options={})
        raise ParseError, 'Fortnight number must be between 0 and 26' unless value.in?(0..26)
        time = Time.zone.local(options[:year] || Time.zone.now.year)
        time + (value * 2).weeks
      end

      def quarter(value, options={})
        value = try_string_to_int(value)
        case value
          when Integer then quarter_integer(value, options)
          else date(value)
        end
      end

      def quarter_integer(value, options={})
        raise ParseError, 'Quarter number must be between 1 and 4' unless value.in?(1..4)
        time = Time.zone.local(options[:year] || Time.zone.now.year)
        time.beginning_of_year + ((value - 1) * 3).months
      end

      def month(value, options={})
        value = try_string_to_int(value)
        case value
          when Integer, String then month_integer(value, options)
          else date(value)
        end
      end

      def month_integer(value, options={})
        year = options[:year] || Time.zone.now.year
        Time.zone.parse "#{year}-#{value}-01"
      rescue
        raise ParseError, 'Month must be a number between 1 and 12 or a month name'
      end

      def year(value, options={})
        value = try_string_to_int(value)
        case value
          when Integer then year_integer(value)
          else date(value)
        end
      end

      def year_integer(value)
        Time.zone.local(extrapolate_year(value))
      end

      def extrapolate_year(value)
        case value.to_i
          when 0..69
            2000 + value
          when 70..99
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

      def time_in_units(seconds)
        days = seconds / 1.day
        time = Time.at(seconds).utc
        { days: days, hour: time.hour, min: time.min, sec: time.sec }
      end

      def apply_offset_start(time, offset)
        units = time_in_units(offset)
        time += units.delete(:days).days
        time.change(units)
      end

      def apply_offset_end(time, offset)
        units = time_in_units(offset)
        time += units.delete(:days).days
        (time + 1.day).change(units) - 1.second
      end
    end
  end
end
