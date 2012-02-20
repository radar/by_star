# by_*


by_* (by_star) is a plugin that allows you to find ActiveRecord objects given certain date objects. This was originally crafted for only finding objects within a given month, but now has extended out to much more. It now supports finding objects for:

* A given year
* A given month
* A given fortnight
* A given week
* A given weekend
* A given day
* The current weekend
* The current work week
* The Past
* The Future
* Between certain times
* Before a specific record
* After a specific record

All methods return scopes. I love these. You love these. Everybody loves these.

It also allows you to do nested finds on the records returned which I personally think is the coolest feature of the whole plugin:

    Post.by_month(1).include(:tags).where("tags.name" => "ruby")

If you're not using the standard `created_at` field: don't worry! I've covered that scenario too.

## Scoping the find

You can treat all `by_*` methods exactly how you would treat normal, every-day ActiveRecord scopes. This is because all `by_*` methods return `ActiveRecord::Relation` objects, with the exception of `previous` and `next`, which return a single record. You can call them like this:

    Post.by_month.your_scope

Where `my_special_scope` is a `named_scope` you have specified.

You can also call typical `ActiveRecord::Relation` methods on the `by_*` methods (like I showed before):

   Post.by_month.include(:tags).where("tags.name" => "ruby")

Want to count records? Simple:

   Post.by_month.count


## By Year (`by_year`)

To find records from the current year, simply call the method without any arguments:

    Post.by_year

To find records based on a year you can pass it a two or four digit number:

    Post.by_year(09)

This will return all posts in 2009, whereas:

    Post.by_year(99)

will return all the posts in the year 1999.

You can also specify the full year:

    Post.by_year(2009)
    Post.by_year(1999)

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

     Post.by_month(Time.local(2012, 11, 24))

This will find all the posts in November 2012.

## By Fortnight (`by_fortnight`)

Fortnight numbering starts at 0. The beginning of a fortnight is Monday, 12am.

To find records from the current fortnight:

    Post.by_fortnight

To find records based on a fortnight, you can pass in a number (representing the fortnight number) or a time object:

    Post.by_fortnight(18)

This will return all posts in the 18th fortnight of the current year.

    Post.by_fortnight(18, :year => 2012)

This will return all posts in the 18th fortnight week of 2012.

    Post.by_fortnight(Time.local(2012,1,1))

This will return all posts from the first fortnight of 2012.

## By Week (`by_week`)

Week numbering starts at 0. The beginning of a week is Monday, 12am.

To find records from the current week:

    Post.by_week

To find records based on a week, you can pass in a number (representing the week number) or a time object:

    Post.by_week(36)

This will return all posts in the 36th week of the current year.

    Post.by_week(36, :year => 2012)

This will return all posts in the 36th week of 2012.

    Post.by_week(Time.local(2012,1,1))

This will return all posts from the first week of 2012.

## By Weekend (`by_weekend`)

If the time passed in (or the time now is a weekend) it will return posts from 12am Saturday to 11:59:59PM Sunday. If the time is a week day, it will show all posts for the coming weekend.

    Post.by_weekend(Time.now)

## By Day (`by_day` or `today`)

To find records for today:

    Post.by_day
    Post.today

To find records for a certain day:

    Post.by_day(Time.local(2012, 1, 1))

You can also pass a string:

    Post.by_day("next tuesday")

This will return all posts for the given day.

## Tomorrow (`tomorrow`)

*This method has been shown to be shifty when passed a `Date` object, it is recommended that you pass it an `ActiveSupport::TimeWithZone` object instead.*

To find all posts from the day after the current date:

    Post.tomorrow

To find all posts after a given Date or Time object:

    Post.tomorrow(Date.today + 2)
    Post.tomorrow(Time.now + 5.days)

You can also pass a string:

    Post.tomorrow("next tuesday")

## Yesterday (`yesterday`)

*This method has been shown to be shifty when passed a `Date` object, it is recommended that you pass it an `ActiveSupport::TimeWithZone` object instead.*

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

## Previous (`previous`)

To find the record prior to this one call `previous` on any model instance:

    Post.last.previous

You can specify a field also:

    Post.last.previous("published_at")

## Next (`next`)

To find the record after this one call `next` on any model instance:

    Post.last.next

You can specify a field also:

    Post.last.next("published_at")

## Not using created_at? No worries!

If your database uses something other than `created_at` for storing a timestamp, you can specify the field option like this:

    Post.by_month("January", :field => :something_else)

All methods support this extra option.

Or if you're doing it all the time on your model, then it's best to use `by_star_field` at the top of your model:

    class Post < ActiveRecord::Base
      by_star_field :something_else
    end

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
* Sam Elliott (lenaryg)
* The dude(s) & gal(s) who created Chronic
* Erik Fonselius

## Suggestions?

If you have suggestions, please contact me at radarlistener@gmail.com
