# by_*


by_* (byStar) is a plugin that allows you to find ActiveRecord objects given certain date objects. This was originally crafted for only finding objects within a given month, but now has extended out to much more. It now supports finding objects for:

* A given year
* A given month
* A given fortnight
* A given week
* A given weekend
* A given day
* The current weekend
* The current work week
* Between certain times
* As of a certain time
* Up to a certain time


It also allows you to do nested finds on the records returned which I personally think is the coolest feature of the whole plugin:
   
    Post.by_month(1) do
      { :include => "tags", :conditions => ["tags.name = ?", 'ruby'] }
    end
    
If you're not using the standard `created_at` field: don't worry! I've covered that scenario too.

## count_by* methods

`count_by` methods can be scoped to only count those records which have a specific field set, and you do this by specifying the symbol version of the name of the field, e.g;

    Invoice.count_by_year(:value)
    
If you want to specify further arguments but do not care about the scoped field:

    Invoice.count_by_year(:all, 2009)


## By Year (`by_year`)

To find records based on a year you can pass it a two or four digit number:
    
    Post.by_year(09)
    
This will return all posts in 2009, whereas:

    Post.by_year(99)

will return all the posts in the year 1999.

You can also specify the full year:
    
    Post.by_year(2009)
    Post.by_year(1999)
    
When you specify a year *less than* 1902 and *greater than* 2039 using specific versions of Ruby (i.e. 1.8.6p114) an `ArgumentError` will be raised. We recommend you upgrade Ruby to *at least* 1.8.7 to stop this problem occuring.

## Sum By Year (`sum_by_year`)

To sum records for the current year based on a field:
    
    Invoice.sum_by_year(:value)

To sum records for a year based on a field:

    Invoice.sum_by_year(:value, 09)
    
You can also pass it a full year:
   
    Invoice.sum_by_year(:value, 2009)
    
## Count By Year (`count_by_year`)

To count the records in the current year regardless of field:

    Invoice.count_by_year
    
To count records in the current year where only a specific field is set:

    Invoice.count_by_year(:value)
  
To count records in a different year regardless of field:

    Invoice.count_by_year(:all, :year => 2009)
   
## By Month (`by_month`)

If you know the number of the month you want:
 
    Post.by_month(1)
    
This will return all posts in the first month (January) of the current year.

If you like being verbose:

    Post.by_month("January")

This will return all posts created in January of the current year. 

If you want to find all posts in January of last year just do 
    
    Post.by_month(1, :year => 2007)
    
or
    
    Post.by_month("January", :year => 2007)
  
This will perform a find using the column you've specified.

If you have a Time object you can use it to find the posts:

     Post.by_month(Time.local(2008, 11, 24))
     
This will find all the posts in November 2008.

When you specify a year *less than* 1902 and *greater than* 2039 using specific versions of Ruby (i.e. 1.8.6p114) an `ArgumentError` will be raised. We recommend you upgrade Ruby to *at least* 1.8.7 to stop this problem occuring.


## Sum By Month (`sum_by_month`)

To sum records for the current month:

    Invoice.sum_by_month

To sum records for a numbered month based on a field:

    Invoice.sum_by_month(:value, 9)
    
You can also specify the name of the month:

    Invoice.sum_by_month(:value, "September")
    
You can also lookup on a different year:
   
    Invoice.sum_by_year(:value, 9, :year => "2009")

## Count By Month (`count_by_month`)

To count records for the current month regardless of field:

    Invoice.count_by_month

To count records for the current month where only a specific field is set:

    Invoice.count_by_month(:value)
    
To count records for a different month regardless of field:
   
    Invoice.count_by_month(:all, 9)
    
To count records for a different month in the current year:

    Invoice.count_by_month(:number, 9)
    
To count records for a different month in a different year:
   
    Invoice.count_by_month(:number, 9, :year => 2008)
    
## By Fortnight (`by_fortnight`)

Fortnight numbering starts at 0. The beginning of a fortnight is Monday, 12am.

To find records from the current fortnight:
    
    Post.by_fortnight
    
To find records based on a fortnight, you can pass in a number (representing the fortnight number) or a time object:

    Post.by_fortnight(18)
   
This will return all posts in the 18th fortnight of the current year.

    Post.by_fortnight(18, :year => 2008)
    
This will return all posts in the 18th fortnight week of 2008.

    Post.by_fortnight(Time.local(2008,1,1))
    
This will return all posts from the first fortnight of 2008.

## By Week (`by_week`)

Week numbering starts at 0. The beginning of a week is Monday, 12am.

To find records from the current week:

    Post.by_week
    
To find records based on a week, you can pass in a number (representing the week number) or a time object:

    Post.by_week(36)
   
This will return all posts in the 36th week of the current year.

    Post.by_week(36, :year => 2008)
    
This will return all posts in the 36th week of 2008.

    Post.by_week(Time.local(2008,1,1))
    
This will return all posts from the first week of 2008.

## By Weekend (`by_weekend`)

If the time passed in (or the time now is a weekend) it will return posts from 12am Saturday to 11:59:59PM Sunday. If the time is a week day, it will show all posts for the coming weekend.

    Post.by_weekend(Time.now)
   
## By Day (`by_day` or `today`)

To find records for today:
    
    Post.by_day
    Post.today
    
To find records for a certain day:

    Post.by_day(Time.local(2008, 1, 1))

You can also pass a string:
    
    Post.by_day("next tuesday")
   
This will return all posts for the given day.

## Current Weekend (`by_current_weekend`)

If you are currently in a weekend (between 3pm Friday and 3am Monday) this will find all records starting at 3pm the previous Friday up until 3am, Monday.

If you are not in a weekend (between 3am Monday and 3pm Friday) this will find all records from the next Friday 3pm to the following Monday 3am.

## Current Work Week (`by_current_work_week`)

If you are currently in a work week (between 3am Monday and 3pm Friday) this will find all records in that range. If you are currently in a weekend (between 3pm Friday and 3am Monday) this will return all records in the upcoming work week.


## Tomorrow (`tomorrow`)

*This method has been shown to be shifty when passed a `Date` object, it is recommended that you pass it a `Time` object instead.*

To find all posts from the day after the current date:

    Post.tomorrow
    
To find all posts after a given Date or Time object:
    
    Post.tomorrow(Date.today + 2)
    Post.tomorrow(Time.now + 5.days)
    
You can also pass a string:
 
    Post.tomorrow("next tuesday")
    
## Yesterday (`yesterday`)

*This method has been shown to be shifty when passed a `Date` object, it is recommended that you pass it a `Time` object instead.*

To find all posts from the day before the current date:

    Post.yesterday
    
To find all posts before a given Date or Time object:
    
    Post.yesterday(Date.today + 2)
    Post.yesterday(Time.now + 5.days)
    
You can also pass a string:
 
    Post.yesterday("next tuesday")
    
## Past (`past`)

To find all posts before the current time:

    Post.past

To find all posts before certain time or date:

    Post.past(Date.today + 2)
    Post.past(Time.now + 5.days)
    
You can also pass a string:

    Post.past("next tuesday")

## Future (`future`)

To find all posts after the current time:

    Post.future

To find all posts after certain time or date:

    Post.future(Date.today + 2)
    Post.future(Time.now + 5.days)
    
You can also pass a string:

    Post.future("next tuesday")
    
## Between (`between`)

To find records between two times:

    Post.between(time1, time2)
    
Also works with dates:
    
    Post.between(date1, date2)
    
And with strings:

    Post.between("last tuesday", "next wednesday")
    
## As of (`as_of_<dynamic>`)

To find records as of a certain date up until the current time:
    
    Post.as_of_2_weeks_ago
    
This uses the Chronic "human mind reading" (read: it's really good at determining what time you mean using written English) library to work it out.

## Up to (`up_to_<dynamic>`)

To find records up to a certain time from the current time:

    Post.up_to_6_weeks_from_now

## Not using created_at? No worries!

If your database uses something other than `created_at` for storing a timestamp, you can specify the field option like this:

    Post.by_month("January", :field => :something_else)
    
All methods support this extra option.

## Scoping the find

All the `by_*` methods take a block which will then scope the find based on the options passed into it. You can also specify these options for each method, but the syntax may differ. The supported options are the same options that are supported by `find` from ActiveRecord. Please note that if you want to use conditions you *have* to use this syntax:

     Post.by_month(1) { { :include => "tags", :conditions => ["tags.name = ?", 'ruby'] } }

or the lengthened:

     Post.by_month(1) do
       { :include => "tags", :conditions => ["tags.name = ?", 'ruby'] }
     end
    
An alternative syntax to this is:

     Post.by_month(1, { :include => "tags", :conditions => ["tags.name = ?", 'ruby'] })
     
## Ordering records

To order the returned set of records you may specify an `:order` option which works the same was as a standard AR `:order` option:

     Item.by_month(1, :order => "position DESC")

     
## "Chronicable string"

This means a string that can be parsed with the Chronic gem.
     
## Collaborators
  
Unfortunately I forget who exactly prompted me to write the plugin, but I would like to thank #rubyonrails for their support and the following people:

* Mislav Marohnic
* August Lilleas (leethal)
* gte351s
* Thomase Sinclair (anathematic)
* The dude(s) & gal(s) who created Chronic
     
## Suggestions?

If you have suggestions, please contact me at radarlistener@gmail.com