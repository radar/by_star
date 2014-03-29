class Post < ActiveRecord::Base
end

class Event < ActiveRecord::Base
  by_star_field :start_time, :end_time, offset: 3.hours
end
