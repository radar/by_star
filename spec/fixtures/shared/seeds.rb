%w(2013-12-31
   2014-01-01
   2014-01-01
   2014-01-05
   2014-01-10
   2014-01-12
   2014-01-20
   2014-02-01
   2014-02-15
   2014-03-01
   2014-03-15
   2014-04-01
   2014-04-15).map{|d| Time.zone.parse(d) + 17.hours }.each do |d|
  Post.create!(:created_at => d)
  Event.create!(:start_time => d - 5.days, :end_time => d + 5.days)
end
