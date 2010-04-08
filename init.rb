require 'by_star'
ActiveRecord::Base.send :include, ByStar
ActiveRecord::Relation.send :include, ByStar if ActiveRecord.const_defined?("Relation")