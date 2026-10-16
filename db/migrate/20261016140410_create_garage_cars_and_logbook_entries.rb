class CreateGarageCarsAndLogbookEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :garage_cars do |t|
      t.references :pilot, foreign_key: true
      t.string :make, null: false
      t.string :model, null: false
      t.integer :year
      t.string :car_class, default: "Street", null: false
      t.decimal :mass_kg, precision: 6, scale: 1
      t.integer :power_hp
      t.decimal :weight_power_ratio, precision: 5, scale: 2
      t.string :drivetrain, default: "RWD", null: false
      t.text :specs # suspension, brakes, engine, aero, safety
      t.string :image_url
      t.boolean :for_rent, default: false, null: false
      t.boolean :car_of_the_week, default: false, null: false
      t.timestamps
    end

    create_table :logbook_entries do |t|
      t.references :garage_car, null: false, foreign_key: true
      t.references :event, foreign_key: true
      t.references :lap_result, foreign_key: true
      t.references :gps_dyno_run, foreign_key: true
      t.string :title, null: false
      t.text :content
      t.date :date
      t.string :onboard_video_url
      t.string :onboard_video_platform # youtube, vk, rutube
      t.timestamps
    end

    add_index :garage_cars, :car_of_the_week
    add_index :garage_cars, :car_class
    add_index :garage_cars, :for_rent
  end
end
