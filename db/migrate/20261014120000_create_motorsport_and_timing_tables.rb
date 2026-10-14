class CreateMotorsportAndTimingTables < ActiveRecord::Migration[7.0]
  def change
    # 1. Teams
    create_table :teams do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :city
      t.text :description
      t.string :logo_url
      t.integer :points, default: 0, null: false
      t.timestamps
    end
    add_index :teams, :slug, unique: true

    # 2. Add extra fields to pilots
    add_reference :pilots, :team, foreign_key: true, optional: true
    add_column :pilots, :bio, :text
    add_column :pilots, :hometown, :string
    add_column :pilots, :avatar_url, :string
    add_column :pilots, :racing_number, :integer
    add_column :pilots, :points, :integer, default: 0, null: false
    add_column :pilots, :starts_count, :integer, default: 0, null: false
    add_column :pilots, :podiums_count, :integer, default: 0, null: false
    add_column :pilots, :wins_count, :integer, default: 0, null: false

    # 3. Championships & Series
    create_table :championships do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :category, default: "circuit", null: false
      t.text :description
      t.string :logo_url
      t.string :rules_url
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :championships, :slug, unique: true

    # 4. Championship Seasons
    create_table :championship_seasons do |t|
      t.references :championship, null: false, foreign_key: true
      t.integer :year, null: false
      t.string :title, null: false
      t.timestamps
    end
    add_index :championship_seasons, [:championship_id, :year], unique: true

    # 5. Championship Stages
    create_table :championship_stages do |t|
      t.references :championship_season, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :stage_number, null: false
      t.date :date, null: false
      t.string :title, null: false
      t.string :status, default: "upcoming", null: false
      t.timestamps
    end

    # 6. Championship Standings
    create_table :championship_standings do |t|
      t.references :championship_season, null: false, foreign_key: true
      t.references :pilot, null: false, foreign_key: true
      t.references :team, foreign_key: true
      t.string :racing_class, null: false
      t.integer :position, null: false
      t.decimal :points, precision: 6, scale: 1, default: 0.0, null: false
      t.timestamps
    end

    # 7. Timing Sessions
    create_table :timing_sessions do |t|
      t.references :track, null: false, foreign_key: true
      t.references :event, foreign_key: true
      t.string :name, null: false
      t.string :session_type, default: "track_day", null: false
      t.datetime :started_at
      t.string :status, default: "live", null: false
      t.string :weather_temp
      t.string :track_temp
      t.string :condition, default: "Сухо"
      t.timestamps
    end

    # 8. Add timing session & sector fields to lap_results
    add_reference :lap_results, :timing_session, foreign_key: true
    add_column :lap_results, :lap_number, :integer
    add_column :lap_results, :sector_1_time, :decimal, precision: 6, scale: 3
    add_column :lap_results, :sector_2_time, :decimal, precision: 6, scale: 3
    add_column :lap_results, :sector_3_time, :decimal, precision: 6, scale: 3
    add_column :lap_results, :top_speed, :decimal, precision: 5, scale: 1
    add_column :lap_results, :gap, :string

    # 9. GpsDyno Runs
    create_table :gps_dyno_runs do |t|
      t.references :pilot, foreign_key: true
      t.string :title, null: false
      t.string :car_model, null: false
      t.decimal :car_mass_kg, precision: 6, scale: 1, null: false
      t.integer :calculated_hp, null: false
      t.integer :calculated_torque_nm, null: false
      t.string :standard, default: "SAE J1349", null: false
      t.date :run_date
      t.jsonb :chart_data
      t.string :source_file_name
      t.timestamps
    end
  end
end
