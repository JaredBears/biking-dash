class CreateReportedBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :reported_bikes do |t|
      t.integer :bike_id,   null: false, foreign_key: true
      t.integer :report_id,  null: false, foreign_key: true

      t.timestamps
    end

    add_index :reported_bikes, [:bike_id, :report_id], unique: true

  end
end
