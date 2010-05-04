require 'chronic'
require 'shared'
require 'range_calculations'
require 'time_ext'
require 'vanilla'
require 'neighbours'

Dir[File.dirname(__FILE__) + '/calculations/*.rb'].each { |file| require file }
require 'calculations'
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
