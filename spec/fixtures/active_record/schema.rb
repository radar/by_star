ActiveRecord::Schema.define do
  self.verbose = false

  create_table :posts, force: true do |t|
    t.timestamps
    t.integer :day_of_month
  end

  create_table :events, force: true do |t|
    t.timestamps
    t.datetime :start_time, :end_time
    t.integer  :day_of_month
  end

  create_table :appointments, force: true do |t|
    t.timestamps
    t.integer :day_of_month
  end
end
