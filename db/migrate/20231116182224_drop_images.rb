class DropImages < ActiveRecord::Migration[7.0]
  def change
    drop_table :images if table_exists? :images
  end
end
