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
  by_star_field :start_time
  named_scope :secret, :conditions => { :public => false }
end

class Invoice < ActiveRecord::Base
  has_many :day_entries
  def self.factory(value, created_at = nil)
    create!(:value => value, :created_at => created_at, :number => value)
  end
end

class DayEntry < ActiveRecord::Base

end

## seed data:

year = Time.zone.now.year

1.upto(12) do |month|
  Post.factory "post #{month}", Time.zone.now.beginning_of_year + (month - 1).months
end

1.upto(12) do |month|
  Invoice.factory 10000, Time.zone.now.beginning_of_year + (month - 1).months
end

# Inovice for 2nd January for sum_by_day
Invoice.factory 5500, Time.zone.now.beginning_of_year + 1.day 

# Invoice from last year
Invoice.factory 10000, Time.local(Time.zone.now.year-1, 1, 1)

# Invoice without a number for count_by_year test
Invoice.create!(:value => 10000, :number => nil) 

Post.factory "Today's post", Time.zone.now
Post.factory "Yesterday's post", Time.zone.now - 1.day
Post.factory "Tomorrow's post", Time.zone.now + 1.day

Post.factory "That's it!", Time.zone.now.end_of_year

# For by_weekend scoped test
# We need to calculate the weekend.
weekend_time = Time.zone.now
weekend_time += 1.day while weekend_time.wday != 6

# For by_weekend scoped test
post = Post.factory "Weekend", weekend_time
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

post = Post.factory "Last year", Time.zone.now.beginning_of_year - 1.year
post.tags.create(:name => "ruby")

post = Post.factory "End of last year", Time.zone.now.end_of_year - 1.year
post.tags.create(:name => "final")

post = Post.factory "The 'Current' Fortnight", Time.zone.now
post.tags.create(:name => "fortnight")

post = Post.factory "The 'Current' Week", Time.zone.now
post.tags.create(:name => "week")


Event.create(:name => "Ryan's birthday!", :start_time  => "04-12-#{Time.zone.now.year}".to_time)
Event.create(:name => "Ryan's birthday, last year!", :start_time  => "04-12-#{Time.zone.now.year-1}".to_time)
Event.create(:name => "Dad's birthday!",  :start_time  => "05-07-#{Time.zone.now.year}".to_time)
Event.create(:name => "Mum's birthday!",  :start_time  => "17-11-#{Time.zone.now.year}".to_time)
Event.create(:name => "Today",            :start_time  => Time.zone.now)
Event.create(:name => "Yesterday",        :start_time  => Time.zone.now.yesterday)
Event.create(:name => "Tomorrow",         :start_time  => Time.zone.now.tomorrow)

# For by_weekend test
Event.create(:name => "1st of August",    :start_time  => "01-08-#{Time.zone.now.year}".to_time)

Event.create(:name => "FBI meeting",      :start_time  => "02-03-#{Time.zone.now.year}".to_time, :public => false)

Invoice.first.day_entries.create(:spent_at => Time.zone.now + 1.hour, :name => "Working harder, better, faster stronger.")