# CHANGELOG

## v2.2.0

* Begin tracking CHANGELOG
* Drop official support for Ruby <= 1.9.2
* Add Ruby 2.1.0, Rubinius, and JRuby to Travis
* Decouple gem from ActiveRecord, and put ActiveRecord and Mongoid specific methods in ORM modules.
* Consolidate all normalization/parsing functions into new Normalization module
* Remove meta-programming methods, e.g. `send("by_week_#{time_klass}")`
* Make Chronic gem optional; use it only if user has included it externally
* by_week always returns a calendar week (i.e. beginning Monday or as specified by Rails setting), regardless of whether Date or Fixnum is given as a parameter.
* by_week and by_calendar_month now supports optional :start_day option (:monday, :tuesday, etc)
* Separate by_calendar_month into it's own class
* by_weekend can now take a fixnum (parsing logic is same as by_week)
* Add Johnny Shields as a gem co-author
