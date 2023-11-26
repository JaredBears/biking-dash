class AddCompleteBluToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :complete_blu, :boolean
  end
end
