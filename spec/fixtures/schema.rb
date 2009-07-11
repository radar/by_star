ActiveRecord::Schema.define do
  self.verbose = false
  
  create_table "categories", :force => true do |t|
    t.string "name"
  end
  
  create_table "groups", :force => true do |t|
    t.string  "name"
    t.integer "owner_id"
  end
  
  create_table "group_users", :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end
  
  create_table "permissions", :force => true do |t|
    t.boolean "can_touch_this",                   :default => false
    t.boolean "can_stop_hammer_time",             :default => false
    t.boolean "can_has_back",                     :default => false
    t.integer "group_id"
    t.integer "thing_id"
    t.integer "category_id"
  end
  
  create_table "things" do |t|
    t.string "name"
    t.integer "parent_id"
    t.integer "category_id"
  end
  
  create_table "users", :force => true do |t|
    t.string "login"
    t.string "password"
  end

end