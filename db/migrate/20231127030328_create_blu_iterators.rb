class CreateBluIterators < ActiveRecord::Migration[7.0]
  def change
    create_table :blu_iterators do |t|
      t.string :iterator, null: false, searchable: true
      t.timestamps
    end
  end
end
