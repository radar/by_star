# For many has_many :through

# Useful stuff defined here
require File.join(File.dirname(__FILE__), 'app/models/permission')
module CanTouchThis
  def self.included(klass)
    klass.class_eval do
      collection = klass.to_s.downcase.pluralize
      has_many "group_#{collection}"
      has_many :groups, :through => "group_#{collection}"
      has_many :permissions, :through => :groups
      
      def global_permissions
        permission = permissions.first
        permission.nil? ? {} : permission.attributes
      end
      
      # Here we can pass an object to check if the user's groups has permissions. 
      # If this object is acting like a tree, it'll work its way all the way up the chain to 
      # the top level element and if all  elements allow access, then it will return true.
      def permissions_for(thing = nil, single = false)
        return {} if thing.nil?
        association = "#{thing.class.to_s.downcase}_id"
        conditions = "permissions.#{association} = '#{thing.id}'"
        permission = permissions.first(:conditions => conditions)
        if permission.nil?
         {}
        else
          attributes = permission.attributes
          # If the model is acting as a tree, look up the chain
          single = true if !thing.respond_to?(:ancestors)
          unless single
            ancestors = thing.ancestors
            for ancestor in ancestors
              attributes.merge!(permissions_for(ancestor, true))
            end
          end
          attributes
        end
      end
      
      # Here we first pass an object that has the object we're wanting to check as a child.
      # Kind of like a blog has many comments, and we're checking the permission of a comment.
      # If the user has permission to the blog, then they will have permission to the comment.
      # If this object is acting like a tree, it'll work its way all the way up the chain to 
      # the top level element and if all  elements allow access, then it will return true.
      def nested_permissions_for(nested, thing = nil, single = false)
        return {} if thing.nil?
        association = "#{thing.class.to_s.downcase}_id"
        conditions = "permissions.#{association} = '#{thing.id}'"
        permission = permissions.first(:conditions => conditions)
        if permission.nil?
         {}
        else
          attributes = permission.attributes
          # If the model is acting as a tree, look up the chain
          single = true if !thing.respond_to?(:ancestors)
          unless single    
            nested_ancestors = [thing.send(nested)]
            nested_ancestors << thing.send(nested).ancestors
            nested_ancestors.compact!
            ancestors += nested_ancestors
            for ancestor in ancestors
              atttributes.merge!(permissions_for(ancestor, true))
            end
          end
          attributes
        end
      end
      
      # Takes the global permissions and merges it with the permissions for an object.
      # The #permissions_for permissions will take precedence over the global permissions.
      def overall_permissions(thing)
        global_permissions.merge!(permissions_for(thing))
      end
      
      def nested_overall_permissions(nested, thing)
        global_permissions.merge!(nested_permissions_for(nested, thing))
      end
            
      # Can the user do this action?
      # If no object is given checks global permissions.
      # If no permissions set for that user then it defaults to false.
      def can?(action, thing = nil)
        !!overall_permissions(thing)["can_#{action}"]
      end
      
      # Can this user do this action in the context of its parent object?
      # If no object given checks global permissions.
      # If no permissions set for that user then it defaults to false.
      def really_can?(nested, action, thing=nil)  
        !!nested_overall_permissions(nested, thing)["can_#{action}"]
      end
    end
  end
end