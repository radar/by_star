require 'chronic'
require 'time_ext'
require 'vanilla'
require 'calculations'
module ByStar
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    include Vanilla
    include Calculations
  end
  
  class ParseError < Exception; end
  class MonthNotFound < Exception; end
end
