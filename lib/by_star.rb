require 'chronic'
require 'shared'
require 'range_calculations'
require 'time_ext'
require 'vanilla'

Dir[File.dirname(__FILE__) + '/calculations/*.rb'].each { |file| require file }
require 'calculations'
module ByStar
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    include RangeCalculations
    include Shared
    include Vanilla
    include Calculations
  end
  
  class ParseError < Exception; end
  class MonthNotFound < Exception; end
end
