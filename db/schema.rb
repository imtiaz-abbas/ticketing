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

ActiveRecord::Schema[7.0].define(version: 2022_03_31_070052) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buyers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "phone"], name: "index_buyers_on_name_and_phone", unique: true
  end

  create_table "shows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", null: false
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_shows_on_date", unique: true
  end

  create_table "tickets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "ticket_number", null: false
    t.uuid "show_id", null: false
    t.uuid "buyer_id"
    t.integer "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_tickets_on_buyer_id"
    t.index ["show_id"], name: "index_tickets_on_show_id"
  end

  add_foreign_key "tickets", "buyers"
  add_foreign_key "tickets", "shows"
end
