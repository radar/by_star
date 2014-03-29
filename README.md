# by_*

[![Build Status](https://travis-ci.org/radar/by_star.png)](https://travis-ci.org/radar/by_star)
[![Code Climate](https://codeclimate.com/github/radar/by_star.png)](https://codeclimate.com/github/radar/by_star)

by_* (by_star) is a plugin that allows you to find ActiveRecord and/or Mongoid objects given certain date objects.


## Installation

Install this gem by adding this to your Gemfile:

```ruby
gem 'by_star', :git => "git://github.com/radar/by_star"
```

Then run `bundle install`.

If you are using ActiveRecord, you're done!

Mongoid users, please include the Mongoid::ByStar module for each model you wish to use the functionality. This is the convention among Mongoid plugins.

```ruby
class MyModel
  include Mongoid::Document
  include Mongoid::ByStar
```

## What it does

This was originally crafted for only finding objects within a given month, but now has extended out to much more. It now supports finding objects for:

* A given year
* A given month
* A given fortnight
* A given week
* A given weekend
* A given day
* A given quarter
* The weeks of a given month as shown on a calendar
* The current weekend
* The current work week
* The Past
* The past month
* The past fortnight
* The past week
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

Because the `previous` and `next` methods cannot have a scoped appended to them, you may pass a `scope` to the options hash, like so:

   @post.next(scope: Post.where(category: @post.category)).count

This would return the next Post that matches `@post`s category

## Time-Range Type Objects

If your object has both a start and end time, you may pass both params to `by_star_field`:

   by_star_field :start_time, :end_time

By default, ByStar queries will return all objects whose range has any overlap within the desired period (permissive):

   MultiDayEvent.by_month("January")  #=> returns MultiDayEvents that overlap in January,
                                          even if they start in December and/or end in February

If you'd like to confine results to starting and ending within the given range, use the `:strict` option:

   MultiDayEvent.by_month("January", strict => true)  #=> returns MultiDayEvents that both start AND end in January

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

## By Calendar Month (`by_calendar_month`)

Finds records for a given month as shown on a calendar. Includes all the results of `by_month`, plus any results which fall in the same week as the first and last of the month. Useful for working with UI calendars which show rows of weeks.

    Post.by_calendar_month

Parameter behavior is otherwise the same as `by_month`. Also, `:start_day` option is supported to specify the start day of the week (`:monday`, `:tuesday`, etc.)

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

This will return all posts in the 37th week of the current year (remember week numbering starts at 0).

    Post.by_week(36, :year => 2012)

This will return all posts in the 37th week of 2012.

    Post.by_week(Time.local(2012,1,1))

This will return all posts from the first week of 2012.

You may pass in a `:start_day` option (`:monday`, `:tuesday`, etc.) to specify the starting day of the week. This may also be configured in Rails.

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

## By Quarter (`by_quarter`)

Finds records by 3-month quarterly period of year. Quarter numbering starts at 1. The four quarters of the year begin on Jan 1, Apr 1, Jul 1, and Oct 1 respectively.

To find records from the current quarter:

    Post.by_quarter

To find records based on a quarter, you can pass in a number (representing the quarter number) or a time object:

    Post.by_quarter(4)

This will return all posts in the 4th quarter of the current year.

    Post.by_quarter(2, :year => 2012)

This will return all posts in the 2nd quarter of 2012.

    Post.by_week(Time.local(2012,1,1))

This will return all posts from the first quarter of 2012.

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

## Past Month (`past_month`)

To find all posts in the past month:

    Post.past_month

## Past Fortnight (`past_fortnight`)

To find all posts in the past fortnight:

    Post.past_fortnight

## Past Week (`past_week`)

To find all posts in the past week:

    Post.past_week

## Before (`before`)

To find all posts before the current time:

    Post.before

To find all posts before certain time or date:

    Post.before(Date.today + 2)
    Post.before(Time.now + 5.days)

You can also pass a string:

    Post.before("next tuesday")

For Time-Range type objects, only the start time is considered for `before`.

## After (`after`)

To find all posts after the current time:

    Post.after

To find all posts after certain time or date:

    Post.after(Date.today + 2)
    Post.after(Time.now + 5.days)

You can also pass a string:

    Post.after("next tuesday")

For Time-Range type objects, only the start time is considered for `after`.

## Between (`between_times`)

To find records between two times:

    Post.between_times(time1, time2)

Also works with dates:

    Post.between_times(date1, date2)

ActiveRecord only: `between` is an alias for `between_times`:

    Post.between(time1, time2)  #=> results identical to between_times above

## Previous (`previous`)

To find the record prior to this one call `previous` on any model instance:

    Post.last.previous

You can specify a field also:

    Post.last.previous("published_at")

For Time-Range type objects, only the start time is considered for `previous`.

## Next (`next`)

To find the record after this one call `next` on any model instance:

    Post.last.next

You can specify a field also:

    Post.last.next("published_at")

For Time-Range type objects, only the start time is considered for `next`.

## Offset option

All ByStar finders support an `:offset` option which offsets the time period for which the query is performed.
This is useful in cases where the daily cycle occurs at a time other than midnight.

    Post.by_day('2014-03-05', offset: 9.hours)

## Not using created_at? No worries!

If your database uses something other than `created_at` for storing a timestamp, you can specify the field option like this:

    Post.by_month("January", :field => :something_else)

All methods support this extra option.

Or if you're doing it all the time on your model, then it's best to use `by_star_field` at the top of your model:

    class Post < ActiveRecord::Base
      by_star_field :something_else
    end

## Chronic Support

If [Chronic](https://github.com/mojombo/chronic) gem is present, it will be used to parse natural-language date/time
strings in all ByStar finder methods. Otherwise, the Ruby `Time.parse` kernel method will be used as a fallback.

As of ByStar 2.2.0, you must explicitly include `gem chronic` into your Gemfile in order to use Chronic.

## Mongoid

Mongoid is only tested/supported on version 3.0+

## Testing

Specify a database by supplying a `DB` environmental variable:

`bundle exec rake spec DB=sqlite`

You can also take an ORM-specific test task for a ride:

`bundle exec rake spec:active_record`


Have an Active Record or Mongoid version in mind? Set the environment variables
`ACTIVE_RECORD_VERSION` and `MONGOID_VERSION` to a version of your choice. A
version number provided will translate to `~> VERSION`, and the string `master`
will grab the latest from Github.

```bash
# Update your bundle appropriately...
ACTIVE_RECORD_VERSION=4.0.0 MONGOID_VERSION=master bundle update

# ...then run the specs
ACTIVE_RECORD_VERSION=4.0.0 MONGOID_VERSION=master bundle exec rpsec spec
```

## Collaborators

Thanks to Thomas Sinclair for the original bump for implementing it. I would like to thank #rubyonrails for their support and the following people:

* Mislav Marohnic
* August Lilleas (leethal)
* gte351s
* Sam Elliott (lenary)
* The people who created [Chronic](https://github.com/mojombo/chronic) gem
* Erik Fonselius
* Johnny Shields (johnnyshields)

## Suggestions?

If you have suggestions, please contact me at radarlistener@gmail.com
