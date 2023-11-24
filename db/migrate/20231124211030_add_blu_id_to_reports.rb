class AddBluIdToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :blu_id, :integer
  end
end
