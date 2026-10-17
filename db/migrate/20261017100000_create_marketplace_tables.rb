class CreateMarketplaceTables < ActiveRecord::Migration[7.0]
  def change
    create_table :market_categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :icon
      t.integer :position, default: 0, null: false
      t.timestamps
    end
    add_index :market_categories, :slug, unique: true

    create_table :market_listings do |t|
      t.references :market_category, null: false, foreign_key: true
      t.references :pilot, foreign_key: true # Seller (pilot/user)
      t.references :garage_car, foreign_key: true # Optional link to verified garage car
      t.string :deal_type, default: "sale", null: false # sale, rent, want
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :price, precision: 12, scale: 2
      t.string :currency, default: "RUB", null: false
      t.string :price_period # per_day, per_trackday, per_stage, null for sales
      t.string :city, null: false
      t.string :status, default: "active", null: false # active, paused, sold
      t.string :contact_name, null: false
      t.string :contact_phone
      t.string :contact_telegram
      t.string :image_url
      t.jsonb :gallery_urls, default: []
      t.jsonb :specs_data, default: {} # additional attributes
      t.timestamps
    end

    add_index :market_listings, :deal_type
    add_index :market_listings, :status
    add_index :market_listings, :city
  end
end
