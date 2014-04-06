module ByStar

  module Kernel

    module Date
      extend ActiveSupport::Concern

      included do

        # Shim to alias Rails 3 #to_time_in_current_zone to Rails 4 name #in_time_zone
        if method_defined?(:to_time_in_current_zone) && !method_defined?(:in_time_zone)
          alias_method :in_time_zone, :to_time_in_current_zone
        end
      end
    end
  end
end

::Date.__send__(:include, ByStar::Kernel::Date)
