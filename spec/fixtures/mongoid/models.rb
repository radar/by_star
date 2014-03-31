class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :day_of_month,        type: Integer
end

class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :st, as: :start_time, type: Time
  field :end_time,            type: Time
  field :day_of_month,        type: Integer

  by_star_field :start_time, :end_time, offset: 3.hours
end
