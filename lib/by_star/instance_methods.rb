module ByStar
  module InstanceMethods
    def previous(options={})
      field = options[:field] || self.class.by_star_field
      (options[:scope] || self.class).where("#{field} < ?", self.send(field)).reorder("#{field} DESC").first
    end

    def next(options={}, scope = nil)
      field = options[:field] || self.class.by_star_field
      (options[:scope] || self.class).where("#{field} > ?", self.send(field)).reorder("#{field} ASC").first
    end
  end
end
