class Post < ActiveRecord::Base
  default_scope :order => "#{quoted_table_name}.created_at ASC"
  has_and_belongs_to_many :tags

  def self.factory(text, created_at = nil)
    create!(:text => text, :created_at => created_at)
  end
end

class Event < ActiveRecord::Base
  by_star_field :start_time
  scope :secret, :conditions => { :public => false }
end
