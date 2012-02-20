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

## seed data:

year = Time.zone.now.year

1.upto(12) do |month|
  Post.factory "post #{month}", Time.zone.now.beginning_of_year + (month - 1).months
end

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

# Offset by two seconds to stop it clashing with "Today's post" in next test
post = Post.factory "The 'Current' Fortnight", Time.zone.now + 2.seconds

post = Post.factory "The 'Current' Week", Time.zone.now + 2.seconds


Event.create(:name => "Ryan's birthday!", :start_time  => "04-12-#{Time.zone.now.year}".to_time)
Event.create(:name => "Ryan's birthday, last year!", :start_time  => "04-12-#{Time.zone.now.year-1}".to_time)
Event.create(:name => "Dad's birthday!",  :start_time  => "05-07-#{Time.zone.now.year}".to_time)
Event.create(:name => "Mum's birthday!",  :start_time  => "17-11-#{Time.zone.now.year}".to_time)
Event.create(:name => "Today",            :start_time  => Time.zone.now)
Event.create(:name => "Yesterday",        :start_time  => Time.zone.now.yesterday)
Event.create(:name => "Tomorrow",         :start_time  => Time.zone.now.tomorrow)
Event.create(:name => "FBI meeting",      :start_time  => "02-03-#{Time.zone.now.year}".to_time, :public => false)
