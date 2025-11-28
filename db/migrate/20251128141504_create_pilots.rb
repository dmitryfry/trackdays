class CreatePilots < ActiveRecord::Migration[7.0]
  def change
    create_table :pilots do |t|
      t.string :name
      t.string :car
      t.string :pilot_class
      t.string :best_lap

      t.timestamps
    end
  end
end
