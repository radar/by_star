module ByStar
  module Neighbours
    # Find the previous record to this.
    def previous(field="created_at")
      self.class.past(self.send(field)) { { :order => "#{field} DESC" }}.first
    end
    
    # Find the next record to this.
    def next(field="created_at")
      self.class.future(self.send(field)) { { :order => "#{field} ASC" }}.first
    end
  end
end