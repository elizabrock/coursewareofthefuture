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

ActiveRecord::Schema.define(version: 20140402184035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.text     "summary"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.string   "title"
    t.text     "syllabus"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_repository"
  end

  create_table "covered_materials", force: true do |t|
    t.integer  "course_id"
    t.string   "material_fullpath"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.integer  "course_id"
    t.datetime "date"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "milestones", force: true do |t|
    t.integer  "assignment_id"
    t.string   "title"
    t.text     "instructions"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_answers", force: true do |t|
    t.integer  "quiz_submission_id"
    t.integer  "question_id"
    t.text     "answer"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer  "quiz_id"
    t.text     "question"
    t.string   "question_type"
    t.text     "correct_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quiz_submissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.datetime "submitted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "graded"
  end

  create_table "quizzes", force: true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "self_reports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "attended"
    t.float    "hours_coding"
    t.float    "hours_learning"
    t.float    "hours_slept"
    t.datetime "date"
  end

  create_table "users", force: true do |t|
    t.string   "email",               default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "phone"
    t.string   "github_uid"
    t.string   "github_username"
    t.string   "github_access_token"
    t.text     "goals"
    t.text     "background"
    t.boolean  "instructor"
    t.boolean  "photo_confirmed",     default: false
    t.string   "photo"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
