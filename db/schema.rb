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

ActiveRecord::Schema.define(version: 20150121175917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignment_problems", force: true do |t|
    t.integer  "assignment_id", null: false
    t.integer  "problem_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignment_problems", ["assignment_id", "problem_id"], name: "index_assignment_problems_on_assignment_id_and_problem_id", unique: true, using: :btree
  add_index "assignment_problems", ["assignment_id"], name: "index_assignment_problems_on_assignment_id", using: :btree
  add_index "assignment_problems", ["problem_id"], name: "index_assignment_problems_on_problem_id", using: :btree

  create_table "assignments", force: true do |t|
    t.integer  "teacher_id",  null: false
    t.string   "title",       null: false
    t.text     "description"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["teacher_id"], name: "index_assignments_on_teacher_id", using: :btree

  create_table "course_assignments", force: true do |t|
    t.integer  "course_id",     null: false
    t.integer  "assignment_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_assignments", ["assignment_id"], name: "index_course_assignments_on_assignment_id", using: :btree
  add_index "course_assignments", ["course_id", "assignment_id"], name: "index_course_assignments_on_course_id_and_assignment_id", unique: true, using: :btree
  add_index "course_assignments", ["course_id"], name: "index_course_assignments_on_course_id", using: :btree

  create_table "course_students", force: true do |t|
    t.integer  "course_id",  null: false
    t.integer  "student_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_students", ["course_id", "student_id"], name: "index_course_students_on_course_id_and_student_id", unique: true, using: :btree
  add_index "course_students", ["course_id"], name: "index_course_students_on_course_id", using: :btree
  add_index "course_students", ["student_id"], name: "index_course_students_on_student_id", using: :btree

  create_table "courses", force: true do |t|
    t.integer  "teacher_id",  null: false
    t.string   "title",       null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "course_code", null: false
  end

  add_index "courses", ["course_code"], name: "index_courses_on_course_code", unique: true, using: :btree
  add_index "courses", ["teacher_id", "title"], name: "index_courses_on_teacher_id_and_title", unique: true, using: :btree
  add_index "courses", ["teacher_id"], name: "index_courses_on_teacher_id", using: :btree

  create_table "problems", force: true do |t|
    t.string   "title",         null: false
    t.text     "body",          null: false
    t.text     "solution",      null: false
    t.decimal  "stella_number"
    t.boolean  "is_original"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  create_table "sessions", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "token",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["token"], name: "index_sessions_on_token", unique: true, using: :btree
  add_index "sessions", ["user_id"], name: "index_sessions_on_user_id", using: :btree

  create_table "student_assignment_links", force: true do |t|
    t.integer  "assignment_id", null: false
    t.integer  "student_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "student_assignment_links", ["assignment_id"], name: "index_student_assignment_links_on_assignment_id", using: :btree
  add_index "student_assignment_links", ["student_id"], name: "index_student_assignment_links_on_student_id", using: :btree

  create_table "teacher_student_links", force: true do |t|
    t.integer  "teacher_id", null: false
    t.integer  "student_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teacher_student_links", ["student_id"], name: "index_teacher_student_links_on_student_id", using: :btree
  add_index "teacher_student_links", ["teacher_id", "student_id"], name: "index_teacher_student_links_on_teacher_id_and_student_id", unique: true, using: :btree
  add_index "teacher_student_links", ["teacher_id"], name: "index_teacher_student_links_on_teacher_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",            null: false
    t.string   "password_digest", null: false
    t.string   "email",           null: false
    t.string   "user_type",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
