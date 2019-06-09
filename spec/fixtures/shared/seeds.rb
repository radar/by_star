%w(2013-11-01
   2013-11-30
   2013-12-01
   2013-12-05
   2013-12-08
   2013-12-16
   2013-12-22
   2013-12-25
   2013-12-28
   2013-12-31
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
   2014-04-15).map{|d| Time.zone.parse(d) + 17.hours }.each_with_index do |d, index|
  Post.create!(created_at: d, updated_at: d + index.days, day_of_month: d.day)
  Appointment.create!(created_at: d, day_of_month: d.day)
  Event.create!(created_at: d, start_time: d - 5.days, end_time: d + 5.days, day_of_month: d.day)
end

# Sydney timezone specific records
%w(
  2020-04-05
  2020-10-04
).map{|d| Date.parse(d) }.each do |d|
  [1, 4, 5, 10].each do |h|
    Event.create!(start_time: d + h.hour, end_time: d + h.hour + 30.minutes, created_at: Date.parse('2011-01-01').in_time_zone)
  end
end
