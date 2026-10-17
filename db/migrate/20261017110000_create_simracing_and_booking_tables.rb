class CreateSimracingAndBookingTables < ActiveRecord::Migration[7.0]
  def change
    create_table :sim_servers do |t|
      t.references :track, foreign_key: true
      t.string :name, null: false
      t.string :sim_game, default: "Assetto Corsa", null: false
      t.string :server_ip, null: false
      t.integer :http_port, default: 8081, null: false
      t.integer :tcp_port, default: 9600, null: false
      t.string :track_name, null: false
      t.string :track_config
      t.integer :capacity, default: 24, null: false
      t.integer :online_drivers, default: 0, null: false
      t.string :cars_list # Comma separated car models
      t.string :password
      t.string :cm_join_link # acmanager:// link
      t.string :status, default: "online", null: false # online, offline, maintenance
      t.timestamps
    end

    create_table :sim_lap_records do |t|
      t.references :pilot, foreign_key: true
      t.references :track, foreign_key: true
      t.string :driver_name, null: false
      t.string :car_name, null: false
      t.string :sim_game, default: "Assetto Corsa", null: false
      t.decimal :lap_time, precision: 7, scale: 3, null: false
      t.decimal :sector_1, precision: 6, scale: 3
      t.decimal :sector_2, precision: 6, scale: 3
      t.decimal :sector_3, precision: 6, scale: 3
      t.string :tire_compound
      t.date :record_date, null: false
      t.string :replay_url
      t.timestamps
    end

    create_table :sim_mods do |t|
      t.string :title, null: false
      t.string :mod_type, default: "track", null: false # track, car, app
      t.string :author
      t.string :version
      t.string :download_url, null: false
      t.string :image_url
      t.text :description
      t.timestamps
    end

    create_table :simulator_slots do |t|
      t.string :name, null: false # e.g. "Риг 1 - Pro Direct Drive 20Nm"
      t.text :specs # Wheelbase, Pedals, Rig, Screens, Motion
      t.integer :hourly_rate_rub, default: 1500, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
    end

    create_table :sim_bookings do |t|
      t.references :simulator_slot, null: false, foreign_key: true
      t.references :pilot, foreign_key: true
      t.string :customer_name, null: false
      t.string :customer_phone, null: false
      t.string :customer_email
      t.date :booking_date, null: false
      t.string :time_slot, null: false # e.g. "18:00 - 20:00"
      t.integer :duration_hours, default: 1, null: false
      t.boolean :with_instructor, default: false, null: false
      t.integer :total_price_rub, null: false
      t.string :status, default: "confirmed", null: false # confirmed, cancelled, completed
      t.text :notes
      t.timestamps
    end

    add_index :sim_lap_records, :lap_time
    add_index :sim_bookings, [:booking_date, :time_slot]
  end
end
