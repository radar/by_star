module ByStar
  def by_year
    time = Time.zone.now
    where("created_at >= ? AND created_at <= ?",
            time.beginning_of_year, time.end_of_year)
  end

  private

end

ActiveRecord::Base.send :extend, ByStar
ActiveRecord::Relation.send :extend, ByStar
