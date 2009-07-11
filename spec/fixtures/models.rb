class Post < ActiveRecord::Base
  default_scope :order => "#{quoted_table_name}.created_at ASC"
  has_and_belongs_to_many :tags
  
  def self.factory(text, created_at = nil)
    create!(:text => text, :created_at => created_at)
  end
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

class Event < ActiveRecord::Base
  named_scope :private, :conditions => { :public => false }
end

## seed data:

year = Time.zone.now.year

1.upto(12) do |month|
  month.times do |n|
    Post.factory "post #{n}", Time.local(year, month, 1)
  end
end

Post.factory "Today's post", Time.zone.now
Post.factory "Yesterday's post", Time.zone.now - 1.day
Post.factory "Tomorrow's post", Time.zone.now + 1.day

Post.factory "That's it!", Time.zone.now.end_of_year

# For by_weekend scoped test
post = Post.factory "Weekend of May", "16-05-2009".to_time
post.tags.create(:name => "weekend")

# For by_day scoped test
post = Post.factory "Today", Time.zone.now
post.tags.create(:name => "today")

# For yesterday scoped test
post = Post.factory "Yesterday", Time.zone.now.yesterday
post.tags.create(:name => "yesterday")

# For tomorrow scoped test
post = Post.factory "Tomorrow's Another Day", Time.zone.now.tomorrow
post.tags.create(:name => "tomorrow")

post = Post.factory "Last year", Time.local(year - 1, 1, 1)
post.tags.create(:name => "ruby")

post = Post.factory "The 'Current' Fortnight", Time.local(year, 5, 15)
post.tags.create(:name => "may")

post = Post.factory "The 'Current' Week", Time.local(year, 5, 15)
post.tags.create(:name => "may2")


Event.create(:name => "Ryan's birthday!", :start_time  => "04-12-#{Time.zone.now.year}".to_time)
Event.create(:name => "Dad's birthday!",  :start_time  => "05-07-#{Time.zone.now.year}".to_time)
Event.create(:name => "Mum's birthday!",  :start_time  => "17-11-#{Time.zone.now.year}".to_time)
Event.create(:name => "Today",            :start_time  => Time.zone.now)
Event.create(:name => "Yesterday",        :start_time  => Time.zone.now - 1.day)
Event.create(:name => "Tomorrow",         :start_time  => Time.zone.now + 1.day)

# For by_weekend test
Event.create(:name => "1st of August",    :start_time  => "01-08-#{Time.zone.now.year}".to_time)

Event.create(:name => "FBI meeting",      :start_time  => "02-03-#{Time.zone.now.year}".to_time, :public => false)