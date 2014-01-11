ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.timestamps
  end

  create_table :events, :force => true do |t|
    t.datetime :start_time, :end_time
  end
end
