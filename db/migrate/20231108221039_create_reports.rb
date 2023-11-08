class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.integer :reporter_id,   null: false, foreign_key: true
      t.string :category,       null: false
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_zip
      t.string :lat
      t.string :lng
      t.string :body

      t.timestamps
    end
  end
end
