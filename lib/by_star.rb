module ByStar
  def by_year

  end

end

ActiveRecord::Base.send :include, ByStar
ActiveRecord::Relation.send :include, ByStar
