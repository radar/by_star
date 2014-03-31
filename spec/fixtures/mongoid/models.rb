class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar
end

class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :st, as: :start_time, type: Time
  field :end_time,            type: Time

  by_star_field :start_time, :end_time, offset: 3.hours
end
