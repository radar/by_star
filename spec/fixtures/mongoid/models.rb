class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :day_of_month,        type: Integer
end

class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :day_of_month,        type: Integer

  by_star_field scope: ->{ where(day_of_month: 1) }, index_scope: ->(start){ start - 5.days }
end

class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :st, as: :start_time, type: Time
  field :end_time,            type: Time
  field :day_of_month,        type: Integer

  by_star_field :start_time, :end_time, offset: 3.hours

  default_scope ->{ order_by(day_of_month: :asc) }
end
