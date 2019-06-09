class Post < ActiveRecord::Base
end

class Appointment < ActiveRecord::Base
  by_star_field index_scope: ->(start){ start - 5.days }
end

class Event < ActiveRecord::Base
  by_star_field :start_time, :end_time, offset: 3.hours

  default_scope ->{ order('day_of_month ASC') }
end
