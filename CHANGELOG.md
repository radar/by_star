# CHANGELOG

## v2.2.1 - 2014-04-21

* Allow `previous` and `next` to take the current record in their scope - @pnomolos / @johnnyshields
* Alias `Date#in_time_zone` to `#to_time_in_current_zone` if not already defined (e.g. for Rails <= 3) - @jcypret / @johnnyshields
* Add `oldest` and `newest` methods

## v2.2.0 - 2014-04-01

* Add `:scope` parameter support on all finders - @pnomolos / @johnnyshields
* Feature: Add `past_*` and `next_*` finders - @davegudge
* Bug Fix: `:field`, `:start_field`, and `:end_field` options were being ignored on finder - @johnnyshields / @gamov
* Bug Fix: `by_star_field` should accept options without start/end_time args - @johnnyshields
* Improve readme documentation - @johnnyshields

## v2.2.0.rc1 - 2014-01-14

* Begin tracking CHANGELOG
* Drop official support for Ruby <= 1.9.2
* Add Ruby 2.1.0, Rubinius, and JRuby to Travis
* Decouple gem from ActiveRecord, and put ActiveRecord and Mongoid specific methods in ORM modules.
* Consolidate all normalization/parsing functions into new Normalization module
* Remove meta-programming methods, e.g. `send("by_week_#{time_klass}")`
* Support matching timespan-type objects with distinct start and end times (previously only point-in-time matching was supported)
* Make Chronic gem optional; use it only if user has included it externally
* `by_week` always returns a calendar week (i.e. beginning Monday or as specified by Rails setting), regardless of whether Date or Fixnum is given as a parameter.
* `by_week` and `by_calendar_month` now supports optional `:start_day` option (:monday, :tuesday, etc)
* Separate `by_calendar_month` into it's own class
* Rename `between` method to `between_times` internally, as Mongoid already defines `between`. ActiveRecord has an alias of `between` so interface stays consistent.
* Add `:offset` option to all query methods, in order to offset the time the day begins/ends (for example supposing business cycle begins at 8:00 each day until 7:59:59 the next day)
* `by_weekend` can now take a fixnum (parsing logic is same as by_week)
* Two-digit year now considers 70 to be 1970, and 69 to be 2069 (was previously 40 -> 1940)
* Add Time kernel extensions for fortnight and calendar_month
* Add Johnny Shields as a gem co-author
