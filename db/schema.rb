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

ActiveRecord::Schema.define(version: 20161115051800) do

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
    t.string   "bill_adr1"
    t.string   "bill_adr2"
    t.string   "bill_city"
    t.string   "bill_country"
    t.string   "bill_code"
    t.string   "bill_province"
    t.boolean  "gender"
    t.date     "birth"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "mobile_phone"
    t.boolean  "is_home"
    t.text     "profile_pic",   limit: 65535
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

  create_table "charges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tournament_id"
    t.integer  "tournament_group_num"
    t.integer  "current_members"
    t.integer  "member_one"
    t.integer  "member_two"
    t.integer  "member_three"
    t.integer  "member_four"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "tournament_id"
    t.boolean  "is_organizer"
    t.boolean  "is_admin"
    t.boolean  "is_guest"
    t.boolean  "is_player"
    t.boolean  "is_sponsor"
    t.boolean  "is_spectator"
    t.bigint   "ticket_number"
    t.integer  "ticket_description"
    t.integer  "guest_of"
    t.text     "fname",                 limit: 65535
    t.text     "lname",                 limit: 65535
    t.integer  "group_number"
    t.boolean  "checked_in"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "ticket_transaction_id"
    t.integer  "score"
    t.integer  "guest_number"
    t.index ["ticket_transaction_id"], name: "index_people_on_ticket_transaction_id", using: :btree
    t.index ["tournament_id"], name: "index_people_on_tournament_id", using: :btree
    t.index ["user_id"], name: "index_people_on_user_id", using: :btree
  end

  create_table "ticket_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint   "transaction_number"
    t.integer  "user_id"
    t.decimal  "amount_paid",        precision: 10
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["user_id"], name: "index_ticket_transactions_on_user_id", using: :btree
  end

  create_table "tournament_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tournament_id"
    t.string   "event_name"
    t.time     "start_time"
    t.time     "end_time"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "description"
    t.index ["tournament_id"], name: "index_tournament_events_on_tournament_id", using: :btree
  end

  create_table "tournament_features", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tournament_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id"], name: "index_tournament_features_on_tournament_id", using: :btree
  end

  create_table "tournament_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tournament_id"
    t.string   "image_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id"], name: "index_tournament_images_on_tournament_id", using: :btree
  end

  create_table "tournament_sponsorships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sponsor_type"
    t.text     "description",   limit: 65535
    t.decimal  "ticket_price",                precision: 10
    t.integer  "tournament_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["tournament_id"], name: "index_tournament_sponsorships_on_tournament_id", using: :btree
  end

  create_table "tournament_tickets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "ticket_name"
    t.text     "ticket_desc",   limit: 65535
    t.decimal  "ticket_price",                precision: 10
    t.integer  "tournament_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.index ["tournament_id"], name: "index_tournament_tickets_on_tournament_id", using: :btree
  end

  create_table "tournaments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.string   "private_event_password"
    t.integer  "tickets_left"
    t.integer  "spectator_tickets_left"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "start_date"
    t.float    "longitude",              limit: 24
    t.float    "latitude",               limit: 24
    t.integer  "total_player_tickets"
    t.integer  "total_audience_tickets"
  end

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
    t.integer  "account_id"
    t.boolean  "is_admin"
    t.string   "provider"
    t.string   "uid"
    t.index ["account_id"], name: "index_users_on_account_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "people", "ticket_transactions"
  add_foreign_key "ticket_transactions", "users"
  add_foreign_key "tournament_events", "tournaments"
  add_foreign_key "tournament_features", "tournaments"
  add_foreign_key "tournament_images", "tournaments"
  add_foreign_key "tournament_sponsorships", "tournaments"
  add_foreign_key "tournament_tickets", "tournaments"
  add_foreign_key "users", "accounts"
end
