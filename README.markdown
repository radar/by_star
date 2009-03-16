# by_*


by_* (byStar) is a plugin that allows you to find ActiveRecord objects by specifying an integer representing the position of a month within a year, the month name itself, or a time instance.
It also allows you to do nested finds on the records returned.

## Simple Examples

### Numerical

If you know the number of the month you want:
 
    Post.by_month(1)
    
This will return all posts in the first month (January) of the current year.

### Words

If you like being verbose:

    Post.by_month("January")

This will return all posts created in January of the current year. 

### Searching in the past

If you want to find all posts in January of last year just do 
    
    Post.by_month(1, :year => 2007)
    
or
    
    Post.by_month("January", :year => 2007)
  
    
### Not using created_at? No worries!

If your database uses something other than `created_at` for storing a timestamp, you can do:

    Post.by_month("January", :year => 2007, :field => :something_else)
  
This will perform a find using the column you've specified.

### Supports time objects too!

If you have a Time object you can use it to find the posts:

     t = Time.local(2008, 11, 24)
     Post.by_month(t)
     
This will find all the posts in November 2008.

### Scoping the find

`by_month` takes a block which will then scope the find based on the options passed into it. The supported options are the same options that are supported by `ActiveRecord::Base.find`

     Post.by_month(1) do
       { :include => "tags", :conditions => ["tags.name = ?", 'ruby'] }
     end
     
This will find all posts created in January that have the tag 'ruby'.
