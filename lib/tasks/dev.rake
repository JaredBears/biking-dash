desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  Report.destroy_all
  ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
  ActiveStorage::Blob.all.each { |blob| blob.purge }
end

desc "Import data from the BLU API and WHU API and add it to the database"
task({ :import_blu_data => :environment }) do
  blu = BluController.new
  blu.import_blu_data
end

desc "Test the Map Routing API"
task({ :test_routing => :environment }) do
  pathfinder = PathfinderController.new
  pathfinder.findRoute("6166 N Sheridan Rd, Chicago, IL 60660", "200 S Wacker Dr, Chicago, IL 60606")
end
