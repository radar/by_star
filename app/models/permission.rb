# Extend this in your app, not in the plugin!
class Permission < ActiveRecord::Base
  
  class << self
    
    # Not placed on has_many's because it's used in more than 1 place.
    # Groups (should) have one global permission. Find it.
    # It's the one with all the _id attributes set to nil.
    def global
      hash = {}
      id_attributes.each { |k| hash[k] = nil }
      first(:conditions => hash)
    end
    
    # So can we can dynamically build the stuff.
    def id_attributes
      column_names.grep(/_id$/).delete_if { |a| a == 'group_id' }
    end
  end

end

