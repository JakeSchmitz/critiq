# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140502051353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.string   "activity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "timestamp"
    t.string   "resource_type"
    t.integer  "resource_id"
  end

  create_table "bounties", force: true do |t|
    t.text     "question"
    t.integer  "response_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  create_table "comments", force: true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "rating",           default: 0
    t.string   "ancestry"
    t.boolean  "deleted",          default: false
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "feature_groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.boolean  "singles",     default: false
  end

  create_table "features", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "upvotes"
    t.integer  "downvotes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "feature_group_id"
  end

  create_table "image_assets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "user_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.integer  "product_id",              default: -1
    t.integer  "feature_id",              default: -1
  end

  create_table "likes", force: true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.boolean  "up",            default: true
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "rating",      default: 0
    t.boolean  "active",      default: true
    t.text     "access_list", default: ""
    t.boolean  "hidden",      default: false
    t.string   "password"
    t.string   "link"
    t.string   "video_url"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hashed_password"
    t.integer  "salt"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "email"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "product_id"
    t.integer  "propic_id"
    t.text     "bio"
    t.boolean  "admin",                  default: false
    t.boolean  "critiq_subscription",    default: true
    t.boolean  "drive_subscription",     default: true
    t.boolean  "creator",                default: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "creator_code"
    t.string   "screen_name"
  end

end
