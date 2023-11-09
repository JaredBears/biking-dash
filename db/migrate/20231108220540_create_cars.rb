class CreateCars < ActiveRecord::Migration[7.0]
  enable extension 'citext' unless extension_enabled?('citext')
  def change
    create_table :cars do |t|
      t.string :style
      t.citext :plate, null: false, index: { unique: true }
      t.string :color
      t.string :make
      t.string :model

      t.timestamps
    end
  end
end
