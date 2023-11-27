desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  Report.destroy_all
  ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
  ActiveStorage::Blob.all.each { |blob| blob.purge }
  BluIterator.destroy_all
end

desc "Import data from the BLU API and WHU API and add it to the database"
task({ :import_blu_data => :environment }) do
  initial_count = Report.count
  uri = URI("https://whitehouseuprising.github.io/maps2/data/chicago/all.json")
  response = Net::HTTP.get(uri)
  json = JSON.parse(response)
  r = nil
  json.sort_by! { |report| report["properties"]["id"] }
  starting = Report.count == 0 ? 62800 : Report.order(blu_id: :desc).first.blu_id
  first_index = json.find_index { |report| report["properties"]["id"] == starting }
  json = json[first_index..-1]
  json.each do |report|
    if !Report.exists?(blu_id: report["properties"]["id"])
      r = Report.new(
        blu_id: report["properties"]["id"],
        reporter_id: 1,
        category: report["properties"]["obstruction"],
        lat: report["geometry"]["coordinates"][1],
        lng: report["geometry"]["coordinates"][0],
        complete_blu: false,
      )
      r.save
    end
    r = nil
  end
  
  pp "there are #{Report.count} reports"
  new_count = Report.count - initial_count
  pp "there are #{new_count} new reports"
  uncompleted = Report.where(complete_blu: false).order(blu_id: :asc)
  if uncompleted.count == 0
    pp "there are no incomplete reports"
    exit
  end

  pp "there are #{uncompleted.count} incomplete reports"

  starting = uncompleted.first.blu_id

  continue = true
  iterator = new_count == 0 && BluIterator.count > 0 ? BluIterator.last.iterator : ""

  while continue
    uri = URI("https://feed.bikelaneuprising.com/api/feed?after=#{iterator}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    pp iterator
    if iterator == json["iterator"]
      continue = false
      break
    end
    iterator = json["iterator"]
    if BluIterator.exists?(iterator: iterator)
      next
    end
    json["data"].each do |report|
      if report["id"].to_i < starting
        continue = false
        break
      end
      if Report.exists?(blu_id: report["id"])
        r = Report.find_by(blu_id: report["id"])
        if !r.complete_blu
          report["images"].each do |image|
            if image[-3..-1] == "png"
              next
            end
            pp "adding image #{image} to report #{report["id"]}..."
            r.images.attach(io: URI.open(image), filename: "#{report["id"]}")
            sleep(rand(1..5))
          end
          r.update(
            complete_blu: true,
            created_at: DateTime.strptime(report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ"),
          )
          r.save
        end
      end
      r = nil
    end
    BluIterator.create(iterator: iterator)
    sleep(rand(1..5))
  end
  pp "there are #{Report.where(complete_blu: true).count} complete reports"
end
