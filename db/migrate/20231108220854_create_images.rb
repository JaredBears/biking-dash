class CreateImages < ActiveRecord::Migration[7.0]
  def change
    create_table :images do |t|
      
      t.string :image_url,  null: false, default: 'http://placehold.it/300x300'
      t.integer :ibb_id,    foreign_key: true
      t.integer :report_id, foreign_key: true
      t.integer :owner_id,  foreign_key: true
      t.integer :bike_id,   foreign_key: true
      t.integer :car_id,    foreign_key: true

      t.timestamps
    end
  end
end
