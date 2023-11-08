class CreateReportedCars < ActiveRecord::Migration[7.0]
  def change
    create_table :reported_cars do |t|
      t.integer :car_id,    null: false, foreign_key: true
      t.integer :report_id, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reported_cars, [:car_id, :report_id], unique: true

  end
end
