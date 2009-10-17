module Shared
  def conditions_for_range(start_time, end_time, options = {})
    field = connection.quote_table_name(table_name) << '.' << connection.quote_column_name(options[:field] || "created_at")
    ["#{field} >= ? AND #{field} <= ?", start_time.utc, end_time.utc]
  end
end