
require 'app/models/group'

class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
end

require 'app/models/permission'

class Permission < ActiveRecord::Base
  belongs_to :thing
  belongs_to :category
end

class Thing < ActiveRecord::Base
  has_many :permissions
  has_many :groups, :through => :permissions
  has_many :users, :through => :groups
  
  belongs_to :category
  
  acts_as_tree
end

class Category < ActiveRecord::Base
  has_many :things
end

class User < ActiveRecord::Base
  include CanTouchThis
end

thing = Thing.create!(:name => "it")
sub_thing = Thing.create!(:name => "subby", :parent => thing)

mc_hammer = Category.create!(:name => "MC Hammer")
the_song = mc_hammer.things.create!(:name => "Can't Touch This")

user = User.create!(:login => "radar", :password => "sekret")

group = Group.create!(:name => "Users")
group.users << user
group.permissions.create!(:can_touch_this => true)
group.permissions.create!(:can_touch_this => false, :thing => thing)

user2 = User.create!(:login => "you",  :password => "people")

other_group = Group.create!(:name => "Others")
other_group.users << user2
other_group.permissions.create!(:can_touch_this => true)
other_group.permissions.create!(:can_touch_this => false, :thing => thing)
other_group.permissions.create!(:can_touch_this => true, :thing => sub_thing)
other_group.permissions.create!(:can_touch_this => false, :category => mc_hammer)
other_group.permissions.create!(:can_touch_this => true, :thing => the_song)



