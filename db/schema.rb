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

ActiveRecord::Schema[7.0].define(version: 2026_10_17_110000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "championship_seasons", force: :cascade do |t|
    t.bigint "championship_id", null: false
    t.integer "year", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_id", "year"], name: "index_championship_seasons_on_championship_id_and_year", unique: true
    t.index ["championship_id"], name: "index_championship_seasons_on_championship_id"
  end

  create_table "championship_stages", force: :cascade do |t|
    t.bigint "championship_season_id", null: false
    t.bigint "track_id", null: false
    t.integer "stage_number", null: false
    t.date "date", null: false
    t.string "title", null: false
    t.string "status", default: "upcoming", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_season_id"], name: "index_championship_stages_on_championship_season_id"
    t.index ["track_id"], name: "index_championship_stages_on_track_id"
  end

  create_table "championship_standings", force: :cascade do |t|
    t.bigint "championship_season_id", null: false
    t.bigint "pilot_id", null: false
    t.bigint "team_id"
    t.string "racing_class", null: false
    t.integer "position", null: false
    t.decimal "points", precision: 6, scale: 1, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["championship_season_id"], name: "index_championship_standings_on_championship_season_id"
    t.index ["pilot_id"], name: "index_championship_standings_on_pilot_id"
    t.index ["team_id"], name: "index_championship_standings_on_team_id"
  end

  create_table "championships", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "category", default: "circuit", null: false
    t.text "description"
    t.string "logo_url"
    t.string "rules_url"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_championships_on_slug", unique: true
  end

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
    t.string "source"
    t.string "external_id"
    t.string "source_url"
    t.string "kind", default: "track_day", null: false
    t.string "status", default: "scheduled", null: false
    t.date "ends_on"
    t.datetime "synced_at"
    t.index ["source", "external_id"], name: "index_events_on_source_and_external_id", unique: true, where: "((source IS NOT NULL) AND (external_id IS NOT NULL))"
    t.index ["track_id"], name: "index_events_on_track_id"
  end

  create_table "garage_cars", force: :cascade do |t|
    t.bigint "pilot_id"
    t.string "make", null: false
    t.string "model", null: false
    t.integer "year"
    t.string "car_class", default: "Street", null: false
    t.decimal "mass_kg", precision: 6, scale: 1
    t.integer "power_hp"
    t.decimal "weight_power_ratio", precision: 5, scale: 2
    t.string "drivetrain", default: "RWD", null: false
    t.text "specs"
    t.string "image_url"
    t.boolean "for_rent", default: false, null: false
    t.boolean "car_of_the_week", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_class"], name: "index_garage_cars_on_car_class"
    t.index ["car_of_the_week"], name: "index_garage_cars_on_car_of_the_week"
    t.index ["for_rent"], name: "index_garage_cars_on_for_rent"
    t.index ["pilot_id"], name: "index_garage_cars_on_pilot_id"
  end

  create_table "gps_dyno_runs", force: :cascade do |t|
    t.bigint "pilot_id"
    t.string "title", null: false
    t.string "car_model", null: false
    t.decimal "car_mass_kg", precision: 6, scale: 1, null: false
    t.integer "calculated_hp", null: false
    t.integer "calculated_torque_nm", null: false
    t.string "standard", default: "SAE J1349", null: false
    t.date "run_date"
    t.jsonb "chart_data"
    t.string "source_file_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pilot_id"], name: "index_gps_dyno_runs_on_pilot_id"
  end

  create_table "lap_results", force: :cascade do |t|
    t.integer "session"
    t.decimal "lap_time"
    t.boolean "is_valid"
    t.bigint "event_id"
    t.bigint "pilot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "timing_session_id"
    t.integer "lap_number"
    t.decimal "sector_1_time", precision: 6, scale: 3
    t.decimal "sector_2_time", precision: 6, scale: 3
    t.decimal "sector_3_time", precision: 6, scale: 3
    t.decimal "top_speed", precision: 5, scale: 1
    t.string "gap"
    t.index ["event_id"], name: "index_lap_results_on_event_id"
    t.index ["pilot_id"], name: "index_lap_results_on_pilot_id"
    t.index ["timing_session_id"], name: "index_lap_results_on_timing_session_id"
  end

  create_table "logbook_entries", force: :cascade do |t|
    t.bigint "garage_car_id", null: false
    t.bigint "event_id"
    t.bigint "lap_result_id"
    t.bigint "gps_dyno_run_id"
    t.string "title", null: false
    t.text "content"
    t.date "date"
    t.string "onboard_video_url"
    t.string "onboard_video_platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_logbook_entries_on_event_id"
    t.index ["garage_car_id"], name: "index_logbook_entries_on_garage_car_id"
    t.index ["gps_dyno_run_id"], name: "index_logbook_entries_on_gps_dyno_run_id"
    t.index ["lap_result_id"], name: "index_logbook_entries_on_lap_result_id"
  end

  create_table "market_categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "icon"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_market_categories_on_slug", unique: true
  end

  create_table "market_listings", force: :cascade do |t|
    t.bigint "market_category_id", null: false
    t.bigint "pilot_id"
    t.bigint "garage_car_id"
    t.string "deal_type", default: "sale", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.decimal "price", precision: 12, scale: 2
    t.string "currency", default: "RUB", null: false
    t.string "price_period"
    t.string "city", null: false
    t.string "status", default: "active", null: false
    t.string "contact_name", null: false
    t.string "contact_phone"
    t.string "contact_telegram"
    t.string "image_url"
    t.jsonb "gallery_urls", default: []
    t.jsonb "specs_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_market_listings_on_city"
    t.index ["deal_type"], name: "index_market_listings_on_deal_type"
    t.index ["garage_car_id"], name: "index_market_listings_on_garage_car_id"
    t.index ["market_category_id"], name: "index_market_listings_on_market_category_id"
    t.index ["pilot_id"], name: "index_market_listings_on_pilot_id"
    t.index ["status"], name: "index_market_listings_on_status"
  end

  create_table "pilots", force: :cascade do |t|
    t.string "name"
    t.string "car"
    t.string "pilot_class"
    t.string "best_lap"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.text "bio"
    t.string "hometown"
    t.string "avatar_url"
    t.integer "racing_number"
    t.integer "points", default: 0, null: false
    t.integer "starts_count", default: 0, null: false
    t.integer "podiums_count", default: 0, null: false
    t.integer "wins_count", default: 0, null: false
    t.index ["team_id"], name: "index_pilots_on_team_id"
  end

  create_table "sim_bookings", force: :cascade do |t|
    t.bigint "simulator_slot_id", null: false
    t.bigint "pilot_id"
    t.string "customer_name", null: false
    t.string "customer_phone", null: false
    t.string "customer_email"
    t.date "booking_date", null: false
    t.string "time_slot", null: false
    t.integer "duration_hours", default: 1, null: false
    t.boolean "with_instructor", default: false, null: false
    t.integer "total_price_rub", null: false
    t.string "status", default: "confirmed", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_date", "time_slot"], name: "index_sim_bookings_on_booking_date_and_time_slot"
    t.index ["pilot_id"], name: "index_sim_bookings_on_pilot_id"
    t.index ["simulator_slot_id"], name: "index_sim_bookings_on_simulator_slot_id"
  end

  create_table "sim_lap_records", force: :cascade do |t|
    t.bigint "pilot_id"
    t.bigint "track_id"
    t.string "driver_name", null: false
    t.string "car_name", null: false
    t.string "sim_game", default: "Assetto Corsa", null: false
    t.decimal "lap_time", precision: 7, scale: 3, null: false
    t.decimal "sector_1", precision: 6, scale: 3
    t.decimal "sector_2", precision: 6, scale: 3
    t.decimal "sector_3", precision: 6, scale: 3
    t.string "tire_compound"
    t.date "record_date", null: false
    t.string "replay_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lap_time"], name: "index_sim_lap_records_on_lap_time"
    t.index ["pilot_id"], name: "index_sim_lap_records_on_pilot_id"
    t.index ["track_id"], name: "index_sim_lap_records_on_track_id"
  end

  create_table "sim_mods", force: :cascade do |t|
    t.string "title", null: false
    t.string "mod_type", default: "track", null: false
    t.string "author"
    t.string "version"
    t.string "download_url", null: false
    t.string "image_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sim_servers", force: :cascade do |t|
    t.bigint "track_id"
    t.string "name", null: false
    t.string "sim_game", default: "Assetto Corsa", null: false
    t.string "server_ip", null: false
    t.integer "http_port", default: 8081, null: false
    t.integer "tcp_port", default: 9600, null: false
    t.string "track_name", null: false
    t.string "track_config"
    t.integer "capacity", default: 24, null: false
    t.integer "online_drivers", default: 0, null: false
    t.string "cars_list"
    t.string "password"
    t.string "cm_join_link"
    t.string "status", default: "online", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_sim_servers_on_track_id"
  end

  create_table "simulator_slots", force: :cascade do |t|
    t.string "name", null: false
    t.text "specs"
    t.integer "hourly_rate_rub", default: 1500, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "city"
    t.text "description"
    t.string "logo_url"
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_teams_on_slug", unique: true
  end

  create_table "timing_sessions", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "event_id"
    t.string "name", null: false
    t.string "session_type", default: "track_day", null: false
    t.datetime "started_at"
    t.string "status", default: "live", null: false
    t.string "weather_temp"
    t.string "track_temp"
    t.string "condition", default: "Сухо"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_timing_sessions_on_event_id"
    t.index ["track_id"], name: "index_timing_sessions_on_track_id"
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
    t.string "source_key"
    t.string "official_url"
    t.index ["source_key"], name: "index_tracks_on_source_key", unique: true
  end

  add_foreign_key "championship_seasons", "championships"
  add_foreign_key "championship_stages", "championship_seasons"
  add_foreign_key "championship_stages", "tracks"
  add_foreign_key "championship_standings", "championship_seasons"
  add_foreign_key "championship_standings", "pilots"
  add_foreign_key "championship_standings", "teams"
  add_foreign_key "events", "tracks"
  add_foreign_key "garage_cars", "pilots"
  add_foreign_key "gps_dyno_runs", "pilots"
  add_foreign_key "lap_results", "events"
  add_foreign_key "lap_results", "pilots"
  add_foreign_key "lap_results", "timing_sessions"
  add_foreign_key "logbook_entries", "events"
  add_foreign_key "logbook_entries", "garage_cars"
  add_foreign_key "logbook_entries", "gps_dyno_runs"
  add_foreign_key "logbook_entries", "lap_results"
  add_foreign_key "market_listings", "garage_cars"
  add_foreign_key "market_listings", "market_categories"
  add_foreign_key "market_listings", "pilots"
  add_foreign_key "pilots", "teams"
  add_foreign_key "sim_bookings", "pilots"
  add_foreign_key "sim_bookings", "simulator_slots"
  add_foreign_key "sim_lap_records", "pilots"
  add_foreign_key "sim_lap_records", "tracks"
  add_foreign_key "sim_servers", "tracks"
  add_foreign_key "timing_sessions", "events"
  add_foreign_key "timing_sessions", "tracks"
end
