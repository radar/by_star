require 'by_star/by_year'

module ByStar

  def by_star_field(field=nil)
    @by_star_field ||= field
    @by_star_field || "#{self.table_name}.created_at"
  end

  include ByYear
end

ActiveRecord::Base.send :extend, ByStar
ActiveRecord::Relation.send :extend, ByStar
