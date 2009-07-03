ActiveRecord::Schema.define do
  self.verbose = false
  
  create_table :posts, :force => true do |t|
    t.string :text
    t.timestamps
  end
  
  create_table :posts_tags, :force => true do |t|
    t.integer :post_id, :tag_id
  end
  
  create_table :tags, :force => true do |t|
    t.string :name
    t.timestamps
  end
  
  create_table :events, :force => true do |t|
    t.datetime :start_time, :end_time
    t.string :name
    t.boolean :public, :default => true
  end
  
end