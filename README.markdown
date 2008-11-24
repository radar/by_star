ByMonth
=======

ByMonth is a plugin that allows you to find ActiveRecord objects by specifying an integer representing the position of a month within a year, the month name itself, or a time instance.

Example
=======

Calling, for example +Post.by_month("January")+ should return all posts created in January of the current year. 

If you want to find all posts in January of last year just do +Post.by_month("January", 2007)+.

If your database uses something other than +created_at+ for storing a timestamp, you can do +Post.by_month("January", 2007, "something_else")+ so it finds on the alternate field.


Copyright (c) 2008 Ryan Bigg, released under the MIT license
