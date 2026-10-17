class CreateCommunityAndAuthTables < ActiveRecord::Migration[7.0]
  def change
    # 1. Users
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :role, default: "pilot", null: false # pilot, track_owner, organizer, seller, spectator
      t.string :avatar_url
      t.string :telegram_username
      t.text :bio
      t.references :pilot, foreign_key: true
      t.timestamps
    end
    add_index :users, :email, unique: true

    # 2. Blog Posts / Articles
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.string :category, default: "report", null: false # report, guide, news, setup
      t.text :summary
      t.text :content, null: false
      t.string :cover_image_url
      t.integer :views_count, default: 0, null: false
      t.integer :likes_count, default: 0, null: false
      t.boolean :published, default: true, null: false
      t.datetime :published_at
      t.timestamps
    end
    add_index :articles, :slug, unique: true
    add_index :articles, :category

    # 3. Comments
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end

    # 4. Media Videos
    create_table :media_videos do |t|
      t.string :title, null: false
      t.string :video_url, null: false
      t.string :platform, default: "youtube", null: false # youtube, vk, rutube
      t.string :category, default: "onboard", null: false # onboard, broadcast, tutorial
      t.text :description
      t.string :thumbnail_url
      t.references :track, foreign_key: true
      t.references :pilot, foreign_key: true
      t.timestamps
    end
  end
end
