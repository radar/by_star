module Shared
  def conditions_for_range(start_time, end_time, field=nil)
    field = table_name << '.' << field.to_s if field
    field ||= by_star_field
    ["#{field} >= ? AND #{field} <= ?", start_time.utc, end_time.utc]
  end

  private 
  def scoped_by(options=nil, &block)
    if options && scope = options.call
      with_scope(:find => scope) do
        block.call
      end
    else
      block.call
    end
  end
end