desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  Report.destroy_all
  ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
  ActiveStorage::Blob.all.each { |blob| blob.purge }
end

namespace :blu do
  desc "Import data from the BLU API and WHU API and add it to the database"
  task({ :import_data => :environment }) do
    blu = BluController.new
    blu.import_data
  end
end
