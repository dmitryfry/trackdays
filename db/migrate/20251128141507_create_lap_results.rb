class CreateLapResults < ActiveRecord::Migration[7.0]
  def change
    create_table :lap_results do |t|
      t.integer :session
      t.decimal :lap_time
      t.boolean :is_valid
      t.references :event, null: false, foreign_key: true
      t.references :pilot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
