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

namespace :db_reports do
  desc "Import data from JSON file and add it to the database"
  task({ :import_data => :environment }) do
    json = JSON.parse(File.read("new_reports.json"))
    json.each do |id, report|
      r = Report.new(
        blu_id: report["blu_id"],
        category: report["category"],
        lat: report["lat"],
        lon: report["lon"],
        created_at: report["created_at"],
        address_street: report["address_street"],
        address_zip: report["address_zip"],
        neighborhood: report["neighborhood"],
        suburb: report["suburb"],
        reporter_id: report["reporter_id"],
        id: report["id"]
      )
      if report["images"].present?
        report["images"].each do |image|
          if image[-3..-1] == "png"
            next
          end
          pp "adding image #{image} to report #{r.id}..."
          r.images.attach(io: URI.open(image), filename: "#{r.id}")
          sleep(rand(1..5))
        end
      end
      r.save!
    end
  end

  desc "Export data from the database to a JSON file"
  task({ :export_data => :environment }) do
    json = {}
    Report.all.each do |report|
      json[report.id] = {
        blu_id: report.blu_id,
        category: report.category,
        lat: report.lat,
        lon: report.lon,
        created_at: report.created_at,
        address_street: report.address_street,
        address_zip: report.address_zip,
        neighborhood: report.neighborhood,
        suburb: report.suburb,
        reporter_id: report.reporter_id,
      }
    end
    File.open("db_reports.json","w") do |f|
      f.write(json.to_json)
    end
  end
end
