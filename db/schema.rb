# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_08_221208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "user_type", ["user", "admin", "test"]

  create_table "users", force: :cascade do |t|
    t.citext "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.citext "username", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "address_street", default: "", null: false
    t.string "address_city", default: "Chicago", null: false
    t.string "address_state", limit: 2, default: "IL", null: false
    t.string "address_zip", default: "", null: false
    t.string "phone", default: "", null: false
    t.enum "user_type", default: "user", null: false, enum_type: "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end
  
  create_table "bikes", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.integer "bike_index_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cars", force: :cascade do |t|
    t.string "style"
    t.citext "plate", null: false
    t.string "color"
    t.string "make"
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plate"], name: "index_cars_on_plate", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.string "image_url", default: "http://placehold.it/300x300", null: false
    t.integer "ibb_id"
    t.integer "report_id"
    t.integer "owner_id"
    t.integer "bike_id"
    t.integer "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reported_bikes", force: :cascade do |t|
    t.integer "bike_id", null: false
    t.integer "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bike_id", "report_id"], name: "index_reported_bikes_on_bike_id_and_report_id", unique: true
  end

  create_table "reported_cars", force: :cascade do |t|
    t.integer "car_id", null: false
    t.integer "report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id", "report_id"], name: "index_reported_cars_on_car_id_and_report_id", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.integer "reporter_id", null: false
    t.string "category", null: false
    t.string "address_street"
    t.string "address_city"
    t.string "address_state"
    t.string "address_zip"
    t.string "lat"
    t.string "lng"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end


end
