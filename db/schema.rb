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

ActiveRecord::Schema.define(version: 20180123223511) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade do |t|
    t.string "name"
    t.string "google_ical_link"
    t.string "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log"
    t.datetime "last_performed_at"
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "calendar_uid"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "summary"
    t.string "link"
    t.string "location"
    t.string "hangout_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "topic_id"
    t.string "lesson_type", null: false
    t.integer "level", null: false
    t.string "content", default: ""
    t.string "link_image", default: ""
    t.string "link_summary", default: ""
    t.integer "version", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_lessons_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "category_id"
    t.string "name"
    t.string "summary"
    t.string "path"
    t.integer "version"
    t.string "sha"
    t.integer "size"
    t.string "url"
    t.string "html_url"
    t.string "git_url"
    t.string "download_url"
    t.string "github_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_topics_on_category_id"
  end

  create_table "user_lessons", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "lesson_id"
    t.string "lesson_type", null: false
    t.integer "version", null: false
    t.boolean "complete", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id"
    t.index ["user_id"], name: "index_user_lessons_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "image_url"
    t.boolean "employee"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
