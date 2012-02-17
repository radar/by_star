require 'chronic'

require 'by_star/shared'
require 'by_star/range_calculations'
require 'by_star/time_ext'
require 'by_star/vanilla'
require 'by_star/neighbours'

require 'by_star/calculations/count'
require 'by_star/calculations/sum'

require 'by_star/calculations'

module ByStar

  def self.included(base)
    base.extend ClassMethods
    base.send(:include, InstanceMethods)
    base.class_eval do
      def self.by_star_field(value=nil)
        @by_star_field ||= value
        @by_star_field || "#{self.table_name}.created_at"
      end
    end
  end

  module ClassMethods
    include RangeCalculations
    include Shared
    include Vanilla
    include Calculations
  end

  module InstanceMethods
    include Neighbours
  end

  class ParseError < Exception; end
  class MonthNotFound < Exception; end
end

ActiveRecord::Base.send :include, ByStar
ActiveRecord::Relation.send :include, ByStar if ActiveRecord.const_defined?("Relation")