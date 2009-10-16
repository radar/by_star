class Time
  def beginning_of_weekend
    friday = case self.wday
    when 0
      self.end_of_week.beginning_of_day.advance(:days => -2) 
    when 5
      self.beginning_of_day
    else
      self.beginning_of_week.advance(:days => 4)
    end
    # 3pm, Friday.
    (friday + 15.hours)
  end
  
  def end_of_weekend
    # 3am, Monday.
    # LOL I CHEATED.
    beginning_of_weekend + 3.days - 12.hours
  end
end