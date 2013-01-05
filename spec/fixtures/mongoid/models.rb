class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :text, type: String

  default_scope order_by([[:created_at, :asc]])
  has_and_belongs_to_many :tags

  def self.factory(text, created_at = nil)
    create!(:text => text, :created_at => created_at)
  end

  def self.find_by_text(text)
    where(:text => text).first
  end
end

class Event
  include Mongoid::Document
  include Mongoid::ByStar

  field :start_time, type: DateTime
  field :end_time,   type: DateTime
  field :name,       type: String
  field :public,     type: Boolean, default: true

  by_star_field :start_time
  scope :secret, where(:public => false)

  def self.find_by_name(name)
    where(:name => name).first
  end
end

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::ByStar

  field :name, type: String

  has_and_belongs_to_many :posts
end

class Invoice
  include Mongoid::Document
  include Mongoid::ByStar

  field :value,  type: Integer
  field :number, type: Integer

  has_many :day_entries
end

class DayEntry
  include Mongoid::Document
  include Mongoid::ByStar

  field :spent_at, type: DateTime
  field :name,     type: String

  belongs_to :invoice
end