# ByStar

[![Build Status](https://travis-ci.org/radar/by_star.png)](https://travis-ci.org/radar/by_star)
[![Code Climate](https://codeclimate.com/github/radar/by_star.png)](https://codeclimate.com/github/radar/by_star)

ByStar (by_*) allows you easily and reliably query ActiveRecord and Mongoid objects based on time.

### Examples

```ruby
   Post.by_year(2013)                           # all posts in 2013
   Post.before(Date.today)                      # all posts for before today
   Post.yesterday                               # all posts for yesterday
   Post.between_times(Time.zone.now - 3.hours,  # all posts in last 3 hours
                      Time.zone.now)
   @post.next                                   # next post after a given post
```

## Installation

Install this gem by adding this to your Gemfile:

```ruby
gem 'by_star', git: "git://github.com/radar/by_star"
```

Then run `bundle install`

If you are using ActiveRecord, you're done!

Mongoid users, please include the Mongoid::ByStar module for each model you wish to use the functionality.
This is the convention among Mongoid plugins.

```ruby
class MyModel
  include Mongoid::Document
  include Mongoid::ByStar
```

## Finder Methods

### Base Scopes

ByStar adds the following finder scopes (class methods) to your model to query time ranges.
These accept a `Date`, `Time`, or `DateTime` object as an argument, which defaults to `Time.zone.now` if not specified:

* `between_times(start_time, end_time)` Finds all records occurring between the two given times
* `before(end_time)` Finds all records occurring before the given time
* `after(start_time)` Finds all records occurring after the given time

### Time Range Scopes

ByStar adds additional shortcut scopes based on commonly used time ranges.
See sections below for detailed argument usage of each:

* `by_day`
* `by_week` Allows zero-based week value from 0 to 52
* `by_cweek` Allows one-based week value from 1 to 53
* `by_weekend` Saturday and Sunday only of the given week
* `by_fortnight` A two-week period, with the first fortnight of the year beginning on 1st January
* `by_month`
* `by_calendar_month` Month as it appears on a calendar; days form previous/following months which are part of the first/last weeks of the given month
* `by_quarter` 3-month intervals of the year
* `by_year`

### Relative Scopes

ByStar also adds scopes which are relative to the current time.
Note the `past_*` and `next_*` methods represent a time distance from current time (`Time.zone.now`),
and do not strictly end/begin evenly on a calendar week/month/year (unlike `by_*` methods which do.)

* `today` Finds all occurrences on today's date
* `yesterday` Finds all occurrences on yesterday's date
* `tomorrow` Finds all occurrences on tomorrow's date
* `past_day` Prior 24-hour period from current time
* `past_week` Prior 7-day period from current time
* `past_fortnight` Prior 14-day period from current time
* `past_month` Prior 30-day period from current time
* `past_year` Prior 365-day period from current time
* `next_day` Subsequent 24-hour period from current time
* `next_week` Subsequent 7-day period from current time
* `next_fortnight` Subsequent 14-day period from current time
* `next_month` Subsequent 30-day period from current time
* `next_year` Subsequent 365-day period from current time

### Superlative Finders

Find the oldest or newest records. Returns an object instance (not a relation):

* `newest`
* `oldest`

### Instance Methods

In addition, ByStar adds instance methods to return the next / previous record in the timewise sequence.
Returns an object instance (not a relation):

* `object.next`
* `object.previous`

### Kernel Extensions

ByStar extends the kernel `Date`, `Time`, and `DateTime` objects with the following instance methods,
which mirror the ActiveSupport methods `beginning_of_day`, `end_of_week`, etc:

* `beginning_of_weekend`
* `end_of_weekend`
* `beginning_of_fortnight`
* `end_of_fortnight`
* `beginning_of_calendar_month`
* `end_of_calendar_month`

Lastly, ByStar aliases Rails 3 `Date#to_time_in_current_zone` to the Rails 4 syntax `#in_time_zone`, if it has not already been defined.

## Usage

### Setting the Query Field

By default, ByStar assumes you will use the `created_at` field to query objects by time.
You may specify an alternate field on all query methods as follows:

```ruby
   Post.by_month("January", field: :updated_at)
```

Alternatively, you may set a default in your model using the `by_star_field` macro:

```ruby
   class Post < ActiveRecord::Base
     by_star_field :updated_at
   end
```

### Scoping the Query

All ByStar methods (except `oldest`, `newest`, `previous`, `next`) return `ActiveRecord::Relation` and/or
`Mongoid::Criteria` objects, which can be daisy-chained with other scopes/finder methods:

```ruby
   Post.by_month.your_scope
   Post.by_month(1).include(:tags).where("tags.name" => "ruby")
```

Want to count records? Simple:

```ruby
   Post.by_month.count
```

### :scope Option

You may pass a `:scope` option as a Relation or Proc to all ByStar methods like so:

```ruby
   @post.next(scope: Post.where(category: @post.category))
   @post.next(scope: ->{ where(category: 'blog') })
```

This is particularly useful for `oldest`, `newest`, `previous`, `next` which return a model instance rather than
a Relation and hence cannot be daisy-chained with other scopes.

`previous` and `next` support a special feature that the `:scope` option may take the subject record as an argument:

```ruby
   @post.next(scope: ->(record){ where(category: record.category) })
```

You may also set a default scope in the `by_star_field` macro. (It is recommended this be a Proc):

```ruby
   class Post < ActiveRecord::Base
     by_star_field scope: ->{ where(category: 'blog') }
   end
```

### `:offset` Option

All ByStar finders support an `:offset` option which is applied to time period of the query condition.
This is useful in cases where the daily cycle occurs at a time other than midnight.

For example, if you'd like to find all Posts from 9:00 on 2014-03-05 until 8:59:59.999 on 2014-03-06, you can do:

    Post.by_day('2014-03-05', offset: 9.hours)

You may also set a offset scope in the `by_star_field` macro:

```ruby
   class Post < ActiveRecord::Base
     by_star_field offset: 9.hours
   end
```

### Timespan Objects

If your object has both a start and end time, you may pass both params to `by_star_field`:

```ruby
   by_star_field :start_time, :end_time
```

By default, ByStar queries will return all objects whose range has any overlap within the desired period (permissive):

```ruby
   MultiDayEvent.by_month("January")  #=> returns MultiDayEvents that overlap in January,
                                          even if they start in December and/or end in February
```

### Timespan Objects: `:strict` Option

If you'd like to confine results to only those both starting and ending within the given range, use the `:strict` option:

```ruby
   MultiDayEvent.by_month("January", :strict => true)  #=> returns MultiDayEvents that both start AND end in January
```

### Timespan Objects: Database Indexing and `:index_start` Option

In order to ensure query performance on large dataset, you must add an index to the query field (e.g. "created_at") be indexed. ByStar does **not** define indexes automatically.

Database indexes require querying a range query on a single field, i.e. `start_time >= X and start_time <= Y`.
If we use a single-sided query, the database will iterate through all items either from the beginning or until the end of time.
This poses a challenge for timespan-type objects which have two fields, i.e. `start_time` and `end_time`.
There are two cases to consider:

1) Timespan with `:strict` option, e.g. "start_time >= X and end_time <= Y".

Given that this gem requires start_time >= end_time, we add the converse constraint "start_time <= Y and end_time >= X" to ensure both fields are double-sided, i.e. an index can be used on either field.

2) Timespan without `:strict` option, e.g. "start_time < Y and end_time > X".

This is not yet supported but will be soon.


### Chronic Support

If [Chronic](https://github.com/mojombo/chronic) gem is present, it will be used to parse natural-language date/time
strings in all ByStar finder methods. Otherwise, the Ruby `Time.parse` kernel method will be used as a fallback.

As of ByStar 2.2.0, you must explicitly include `gem chronic` into your Gemfile in order to use Chronic.


## Advanced Usage

### between_times

To find records between two times:

```ruby
   Post.between_times(time1, time2)
```

You use a Range like so:

```ruby
   Post.between_times(time1..time2)
```

Also works with dates - WARNING: there are currently some caveats see [Issue #49](https://github.com/radar/by_star/issues/49):

```ruby
   Post.between_times(date1, date2)
```

### before and after

To find all posts before / after the current time:

```ruby
   Post.before
   Post.after
```

To find all posts before certain time or date:

```ruby
   Post.before(Date.today + 2)
   Post.after(Time.now + 5.days)
```

You can also pass a string:

```ruby
   Post.before("next tuesday")
```

For Time-Range type objects, only the start time is considered for `before` and `after`.

### previous and next

To find the prior/subsequent record to a model instance, `previous`/`next` on it:

```ruby
   Post.last.previous
   Post.first.next
```

You can specify a field also:

```ruby
   Post.last.previous(field: "published_at")
   Post.first.next(field: "published_at")
```

For Time-Range type objects, only the start time is considered for `previous` and `next`.

### by_year

To find records from the current year, simply call the method without any arguments:

```ruby
   Post.by_year
```

To find records based on a year you can pass it a two or four digit number:

```ruby
   Post.by_year(09)
```

This will return all posts in 2009, whereas:

```ruby
   Post.by_year(99)
```

will return all the posts in the year 1999.

You can also specify the full year:

```ruby
   Post.by_year(2009)
   Post.by_year(1999)
```

### by_month

If you know the number of the month you want:

```ruby
   Post.by_month(1)
```

This will return all posts in the first month (January) of the current year.

If you like being verbose:

```ruby
   Post.by_month("January")
```

This will return all posts created in January of the current year.

If you want to find all posts in January of last year just do

```ruby
   Post.by_month(1, year: 2007)
```

or

```ruby
   Post.by_month("January", year: 2007)
```

This will perform a find using the column you've specified.

If you have a Time object you can use it to find the posts:

```ruby
   Post.by_month(Time.local(2012, 11, 24))
```

This will find all the posts in November 2012.

### by_calendar_month

Finds records for a given month as shown on a calendar. Includes all the results of `by_month`, plus any results which fall in the same week as the first and last of the month. Useful for working with UI calendars which show rows of weeks.

```ruby
   Post.by_calendar_month
```

Parameter behavior is otherwise the same as `by_month`. Also, `:start_day` option is supported to specify the start day of the week (`:monday`, `:tuesday`, etc.)

### by_fortnight

Fortnight numbering starts at 0. The beginning of a fortnight is Monday, 12am.

To find records from the current fortnight:

```ruby
   Post.by_fortnight
```

To find records based on a fortnight, you can pass in a number (representing the fortnight number) or a time object:

```ruby
   Post.by_fortnight(18)
```

This will return all posts in the 18th fortnight of the current year.

```ruby
   Post.by_fortnight(18, year: 2012)
```

This will return all posts in the 18th fortnight week of 2012.

```ruby
   Post.by_fortnight(Time.local(2012,1,1))
```

This will return all posts from the first fortnight of 2012.

### by_week and by_cweek

Week numbering starts at 0, and cweek numbering starts at 1 (same as `Date#cweek`). The beginning of a week is as defined in `ActiveSupport#beginning_of_week`, which can be configured.

To find records from the current week:

```ruby
   Post.by_week
   Post.by_cweek  # same result
```

This will return all posts in the 37th week of the current year (remember week numbering starts at 0):

```ruby
   Post.by_week(36)
   Post.by_cweek(37)  # same result
```

This will return all posts in the 37th week of 2012:

```ruby
   Post.by_week(36, year: 2012)
   Post.by_cweek(37, year: 2012)  # same result
```

This will return all posts in the week which contains Jan 1, 2012:

```ruby
   Post.by_week(Time.local(2012,1,1))
   Post.by_cweek(Time.local(2012,1,1))  # same result
```

You may pass in a `:start_day` option (`:monday`, `:tuesday`, etc.) to specify the starting day of the week. This may also be configured in Rails.

### by_weekend

If the time passed in (or the time now is a weekend) it will return posts from 0:00 Saturday to 23:59:59 Sunday. If the time is a week day, it will show all posts for the coming weekend.

```ruby
   Post.by_weekend(Time.now)
```

### by_day and today

To find records for today:

```ruby
   Post.by_day
   Post.today
```

To find records for a certain day:

```ruby
   Post.by_day(Time.local(2012, 1, 1))
```

You can also pass a string:

```ruby
   Post.by_day("next tuesday")
```

This will return all posts for the given day.

### by_quarter

Finds records by 3-month quarterly period of year. Quarter numbering starts at 1. The four quarters of the year begin on Jan 1, Apr 1, Jul 1, and Oct 1 respectively.

To find records from the current quarter:

```ruby
   Post.by_quarter
```

To find records based on a quarter, you can pass in a number (representing the quarter number) or a time object:

```ruby
   Post.by_quarter(4)
```

This will return all posts in the 4th quarter of the current year.

```ruby
   Post.by_quarter(2, year: 2012)
```

This will return all posts in the 2nd quarter of 2012.

```ruby
   Post.by_week(Time.local(2012,1,1))
```

This will return all posts from the first quarter of 2012.


## Version Support

ByStar is tested against the following versions:

* Ruby 1.9.3+
* Rails/ActiveRecord 3.0+
* Mongoid 3.0+

Note that ByStar automatically adds the following version compatibility shims:

* ActiveSupport 3.x: `Date#to_time_in_current_zone` is aliased to `Date#in_time_zone` from version 4+
* Mongoid 3.x: Adds support for `Criteria#reorder` method from version 4+


## Testing

### Test Setup

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

### Test Implementation

ByStar tests use TimeCop to lock the system `Time.now` at Jan 01, 2014, and seed
objects with fixed dates according to `spec/fixtures/shared/seeds.rb`.
Note that the timezone is randomized on each run to shake-out timezone related quirks.


## Collaborators

ByStar is actively maintained by Ryan Biggs (radar) and Johnny Shields (johnnyshields)

Thank you to the following people:

* Thomas Sinclair for the original bump for implementing ByStar
* [Ruby on Rails](http://rubyonrails.org/) for their support
* Mislav Marohnic
* August Lilleas (leethal)
* gte351s
* Sam Elliott (lenary)
* The creators of the [Chronic](https://github.com/mojombo/chronic) gem
* Erik Fonselius
* Johnny Shields (johnnyshields)
