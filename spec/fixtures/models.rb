class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

for month in 1..12
  month.times do
    Post.create(:text => "testing", :created_at => Time.local(Time.now.year, month, 1))
  end
end

# Today's fixture
Post.create!(:text => "Today's post")

# Yesterday's fixture
Post.create!(:text => "Yesterday's post", :created_at => Time.now-1.day)

# Tomorrow's fixture
Post.create!(:text => "Tomorrow's post", :created_at => Time.now+1.day)

# Tag test
post = Post.create(:text => "testing", :created_at => Time.local(Time.now.year-1, 1, 1))
post.tags.create(:name => "ruby")
