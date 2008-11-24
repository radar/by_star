class Post < ActiveRecord::Base
  include Frozenplague::ByMonth
end