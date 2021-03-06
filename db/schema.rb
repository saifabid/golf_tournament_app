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

ActiveRecord::Schema.define(version: 20161130231710) do

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

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "priority",                 default: 0, null: false
    t.integer  "attempts",                 default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
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
    t.time     "start"
    t.time     "end"
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
    t.boolean  "is_dinner"
    t.bigint   "ticket_number"
    t.integer  "ticket_description"
    t.integer  "guest_of"
    t.text     "fname",                 limit: 65535
    t.text     "lname",                 limit: 65535
    t.integer  "group_number"
    t.time     "start"
    t.time     "end"
    t.boolean  "checked_in"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "ticket_transaction_id"
    t.integer  "score"
    t.integer  "guest_number"
    t.boolean  "org_view_public"
    t.boolean  "is_golf_course_admin"
    t.integer  "survey_admin"
    t.boolean  "company_rep"
    t.boolean  "company_csr"
    t.boolean  "golf_course_csr"
    t.index ["ticket_transaction_id"], name: "index_people_on_ticket_transaction_id", using: :btree
    t.index ["tournament_id"], name: "index_people_on_tournament_id", using: :btree
    t.index ["user_id"], name: "index_people_on_user_id", using: :btree
  end

  create_table "rapidfire_answers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "attempt_id"
    t.integer  "question_id"
    t.text     "answer_text", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attempt_id"], name: "index_rapidfire_answers_on_attempt_id", using: :btree
    t.index ["question_id"], name: "index_rapidfire_answers_on_question_id", using: :btree
  end

  create_table "rapidfire_attempts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "survey_id"
    t.string   "user_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["survey_id"], name: "index_rapidfire_attempts_on_survey_id", using: :btree
    t.index ["user_id", "user_type"], name: "index_rapidfire_attempts_on_user_id_and_user_type", using: :btree
  end

  create_table "rapidfire_questions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "survey_id"
    t.string   "type"
    t.string   "question_text"
    t.integer  "position"
    t.text     "answer_options",   limit: 65535
    t.text     "validation_rules", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["survey_id"], name: "index_rapidfire_questions_on_survey_id", using: :btree
  end

  create_table "rapidfire_surveys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint   "transaction_number"
    t.integer  "user_id"
    t.decimal  "amount_paid",        precision: 16, scale: 2
    t.decimal  "card_surcharge",     precision: 16, scale: 2
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "currency",                                    default: "cad", null: false
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

  create_table "tournament_profile_pictures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "tournament_id"
    t.string   "image"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["tournament_id"], name: "index_tournament_profile_pictures_on_tournament_id", using: :btree
  end

  create_table "tournament_sponsorships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sponsor_type"
    t.text     "description",   limit: 65535
    t.decimal  "ticket_price",                precision: 10
    t.integer  "tournament_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "company_logo"
    t.string   "company_name"
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
    t.integer  "dinner_tickets_left"
    t.datetime "created_at",                                                                    null: false
    t.datetime "updated_at",                                                                    null: false
    t.datetime "start_date"
    t.float    "longitude",              limit: 24
    t.float    "latitude",               limit: 24
    t.integer  "total_player_tickets"
    t.integer  "total_audience_tickets"
    t.integer  "total_dinner_tickets"
    t.decimal  "gold_sponsor_price",                   precision: 16, scale: 2, default: "1.0"
    t.text     "gold_sponsor_desc",      limit: 65535
    t.decimal  "silver_sponsor_price",                 precision: 16, scale: 2, default: "1.0"
    t.text     "silver_sponsor_desc",    limit: 65535
    t.decimal  "bronze_sponsor_price",                 precision: 16, scale: 2, default: "1.0"
    t.text     "bronze_sponsor_desc",    limit: 65535
    t.decimal  "player_price",                         precision: 16, scale: 2
    t.decimal  "foursome_price",                       precision: 16, scale: 2
    t.decimal  "spectator_price",                      precision: 16, scale: 2
    t.decimal  "dinner_price",                         precision: 16, scale: 2
    t.decimal  "distance",                             precision: 10
    t.integer  "num_foursomes"
    t.decimal  "player_surcharge",                     precision: 16, scale: 2
    t.decimal  "card_surcharge",                       precision: 16, scale: 2
    t.boolean  "organizer_paid"
    t.string   "contact_name"
    t.string   "contact_email"
    t.boolean  "player_questionnaire"
    t.string   "questionnaire_name"
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
  add_foreign_key "tournament_profile_pictures", "tournaments"
  add_foreign_key "tournament_sponsorships", "tournaments"
  add_foreign_key "tournament_tickets", "tournaments"
  add_foreign_key "users", "accounts"
end
