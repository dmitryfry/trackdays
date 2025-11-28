class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :location
      t.decimal :length_km
      t.integer :turns
      t.string :difficulty
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
