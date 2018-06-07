
ActiveRecord::Schema.define(version: 20160119185429) do

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.string   "hometown"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "author_id"
  end

end
