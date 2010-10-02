module ByStar
  module Neighbours
    # Find the previous record to this.
    def previous(field=nil)
      field = field || self.class.by_star_field
      self.class.past(self.send(field.to_s.split(".").last)) { { :order => "#{field} DESC" }}.first
    end

    # Find the next record to this.
    def next(field=nil)
      field = field || self.class.by_star_field
      self.class.future(self.send(field.to_s.split(".").last)) { { :order => "#{field} ASC" }}.first
    end
  end
end