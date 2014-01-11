ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, :force => true do |t|
    t.string :text
    t.timestamps
  end

  create_table :events, :force => true do |t|
    t.datetime :start_time, :end_time
    t.string :name
    t.boolean :public, :default => true
  end
end
