class AddEventSyncFieldsToTracksAndEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :source_key, :string
    add_index :tracks, :source_key, unique: true
    add_column :tracks, :official_url, :string

    add_column :events, :source, :string
    add_column :events, :external_id, :string
    add_column :events, :source_url, :string
    add_column :events, :kind, :string, default: "track_day", null: false
    add_column :events, :status, :string, default: "scheduled", null: false
    add_column :events, :ends_on, :date
    add_column :events, :synced_at, :datetime

    add_index :events, [:source, :external_id], unique: true, where: "source IS NOT NULL AND external_id IS NOT NULL"
  end
end
