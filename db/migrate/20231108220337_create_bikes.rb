class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.integer :owner_id,      null: false, foreign_key: true
      t.integer :bike_index_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
