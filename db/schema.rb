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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20161001005624) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "prefix"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "suffix"
    t.string   "home_adr1"
    t.string   "home_adr2"
    t.string   "home_city"
    t.string   "home_country"
    t.string   "home_code"
    t.string   "home_province"
    t.boolean  "is_billing"
    t.string   "bill_adr1"
    t.string   "bill_adr2"
    t.string   "bill_city"
    t.string   "bill_country"
    t.string   "bill_code"
    t.string   "bill_province"
    t.boolean  "gender"
    t.date     "birth"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
=======
ActiveRecord::Schema.define(version: 20160927231813) do

  create_table "tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
>>>>>>> origin/master
    t.string   "name"
    t.string   "logo"
    t.string   "language"
    t.string   "currency"
    t.string   "profile_pictures"
    t.string   "details"
    t.string   "venue_name"
    t.string   "venue_logo"
    t.string   "venue_address"
    t.string   "venue_website"
    t.string   "venue_contact_details"
    t.boolean  "is_private"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

<<<<<<< HEAD
  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "accounts", "users"
=======
>>>>>>> origin/master
end
