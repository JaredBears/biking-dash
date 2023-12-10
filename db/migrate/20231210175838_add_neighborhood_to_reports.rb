class AddNeighborhoodToReports < ActiveRecord::Migration[7.0]
  def change
    add_column :reports, :neighborhood, :string
    add_column :reports, :suburb, :string
  end
end
