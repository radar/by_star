class Post < ActiveRecord::Base
  default_scope :order => "created_at ASC"
  has_and_belongs_to_many :tags
  
  def self.factory(text, created_at = nil)
    create!(:text => text, :created_at => created_at)
  end
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

## seed data:

year = Time.now.year

1.upto(12) do |month|
  month.times do |n|
    Post.factory "post #{n}", Time.local(year, month, 1)
  end
end

Post.factory "Today's post"
Post.factory "Yesterday's post", 1.day.ago.utc
Post.factory "Tomorrow's post", 1.day.from_now.utc

post = Post.factory "Last year", Time.local(year - 1, 1, 1)
post.tags.create(:name => "ruby")
