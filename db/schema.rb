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

ActiveRecord::Schema[7.0].define(version: 2025_11_28_141507) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.date "date"
    t.string "title"
    t.integer "slots_total"
    t.integer "slots_booked"
    t.integer "price_rub"
    t.string "organizer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_events_on_track_id"
  end

  create_table "lap_results", force: :cascade do |t|
    t.integer "session"
    t.decimal "lap_time"
    t.boolean "is_valid"
    t.bigint "event_id", null: false
    t.bigint "pilot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_lap_results_on_event_id"
    t.index ["pilot_id"], name: "index_lap_results_on_pilot_id"
  end

  create_table "pilots", force: :cascade do |t|
    t.string "name"
    t.string "car"
    t.string "pilot_class"
    t.string "best_lap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.decimal "length_km"
    t.integer "turns"
    t.string "difficulty"
    t.string "image_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "events", "tracks"
  add_foreign_key "lap_results", "events"
  add_foreign_key "lap_results", "pilots"
end
