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

ActiveRecord::Schema.define(version: 2019_04_15_133720) do

  create_table "accept_certs", force: :cascade do |t|
    t.string "user_id"
    t.integer "course_id"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", id: false, force: :cascade do |t|
    t.string "username"
    t.string "hashed_id", null: false
    t.string "public_addr"
    t.string "public_key"
    t.string "private_key"
    t.string "contract_addr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hashed_id"], name: "index_admins_on_hashed_id", unique: true
  end

  create_table "comp_certs", force: :cascade do |t|
    t.string "user_id"
    t.integer "course_id"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_no", null: false
    t.string "course_session", null: false
    t.text "course_desc"
    t.string "user_id"
    t.boolean "accepted"
    t.datetime "accepted_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inst_certs", force: :cascade do |t|
    t.string "user_id"
    t.integer "course_id"
    t.string "desc"
    t.string "transaction_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_course_mappings", force: :cascade do |t|
    t.string "user_id"
    t.integer "course_id"
    t.boolean "accepted"
    t.boolean "passed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: false, force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "public_addr", null: false
    t.string "public_key"
    t.string "password_digest"
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public_addr"], name: "index_users_on_public_addr", unique: true
  end

end
