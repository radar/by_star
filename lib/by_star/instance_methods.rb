module ByStar
  module InstanceMethods
    def previous(options={})
      field = options[:field] || self.class.by_star_field
      self.class.where("#{field} < ?", self.send(field)).order("#{field} DESC").first
    end

    def next(options={})
      field = options[:field] || self.class.by_star_field
      self.class.where("#{field} > ?", self.send(field)).order("#{field} ASC").first
    end
  end
end
