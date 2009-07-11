require 'can_touch_this'
# Thanks to those who have worked on nested_has_many_through
# Without this, it wouldn't be possible!
require 'nested_has_many_through'

ActiveRecord::Associations::HasManyThroughAssociation.send :include, NestedHasManyThrough::Association
 
# BC
if defined?(ActiveRecord::Reflection::ThroughReflection)
  ActiveRecord::Reflection::ThroughReflection.send :include, NestedHasManyThrough::Reflection
else
  ActiveRecord::Reflection::AssociationReflection.send :include, NestedHasManyThrough::Reflection
end