class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :track, null: false, foreign_key: true
      t.date :date
      t.string :title
      t.integer :slots_total
      t.integer :slots_booked
      t.integer :price_rub
      t.string :organizer

      t.timestamps
    end
  end
end
