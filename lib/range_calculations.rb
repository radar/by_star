module ByStar
  module RangeCalculations

    private
    
    def start_of_year(year=Time.zone.now.year)
      Time.utc(year, 1, 1)
    end
    
    def end_of_year(year=Time.zone.now.year)
      start_of_year.end_of_year
    end
    
    def start_of_month(month, year=Timeow.year)
      Time.utc(year, month, 1)
    end
    
    def end_of_month(month, year=Time.now.year)
      start_of_month(month, year).end_of_month
    end
  end
  
end