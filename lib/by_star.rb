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
