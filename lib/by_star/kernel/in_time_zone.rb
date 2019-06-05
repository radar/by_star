module ByStar

  module Kernel

    module InTimeZone
      extend ActiveSupport::Concern

      included do
        if method_defined?(:to_time_in_current_zone) && !method_defined?(:in_time_zone)
          alias_method :in_time_zone, :to_time_in_current_zone
        end
      end
    end
  end
end

::Date.__send__(:include, ByStar::Kernel::InTimeZone)
::Time.__send__(:include, ByStar::Kernel::InTimeZone)
::DateTime.__send__(:include, ByStar::Kernel::InTimeZone)
::ActiveSupport::TimeWithZone.__send__(:include, ByStar::Kernel::InTimeZone)
