# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users" do |t|
    t.string  "name_en", limit: 64
    t.string  "name_ja", limit: 64
    t.integer "score", default: 0
  end

  create_table "jobs" do |t|
    t.integer  "user_id", null: false
    t.integer  "company_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images" do |t|
    t.string   "name", default: "image", null: false
    t.integer "imageable_id"
    t.string  "imageable_type"
    t.string  "url"
    t.integer "file_width"
    t.integer "file_height"
  end

  create_table "companies", force: true do |t|
    t.string   "name"
    t.date     "founded_on"
    t.string   "url"
    t.text     "origin"
    t.text     "why_description"
    t.text     "what_description"
    t.text     "how_description"
    t.string   "country",              limit: 2, default: "JP", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
