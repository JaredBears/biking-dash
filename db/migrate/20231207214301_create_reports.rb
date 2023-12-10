class CreateReports < ActiveRecord::Migration[7.0]
  def change
    drop_table(:reports, if_exists: true)
    drop_table(:bikes, if_exists: true)
    drop_table(:cars, if_exists: true)
    drop_table(:reported_bikes, if_exists: true)
    drop_table(:reported_cars, if_exists: true)
    drop_table(:blu_iterators, if_exists: true)

    create_enum :category, [
      "Company Vehicle", 
      "Municipal (city) Vehicle - includes USPS",
      "Other  (damaged lane, snow, debris, pedestrian, etc.)",
      "Construction",
      "Private Owner Vehicle",
      "Taxi / Uber / Livery / Lyft"
  ]

    create_table :reports do |t|
      t.string :lat
      t.string :lng
      t.bigint :reporter_id, null: false, foreign_key: true
      t.string :address_street
      t.string :address_zip
      t.bigint :blu_id
      t.boolean :complete_blu, default: false
      t.string :description
      t.enum :category, enum_type: :category, null: false

      t.timestamps
    end
  end
end
