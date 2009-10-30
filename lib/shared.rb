module Shared
  def conditions_for_range(start_time, end_time, field="created_at")
    field = connection.quote_table_name(table_name) << '.' << connection.quote_column_name(field || "created_at")
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