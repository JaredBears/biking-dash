desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  Report.destroy_all
end

desc "Import data from the BLU API and WHU API and add it to the database"
task({ :import_data => :environment }) do
  continue = true
  iterator = ""

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
    json["data"].each do |report|
      r = nil
      if report["city"] != "Chicago, IL"
        next
      end
      if !Report.exists?(blu_id: report["id"]) && report["city"] == "Chicago, IL"
        r = Report.new(
          blu_id: report["id"],
          reporter_id: 1,
          category: "Unknown",
          created_at: DateTime.strptime(report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ"),
          complete_blu: false,
        )
      elsif report["city"] == "Chicago, IL"
        r = Report.find_by(blu_id: report["id"])
        if r.complete_blu
          next
        end
        r.created_at = DateTime.strptime(report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ")
        r.complete_blu = true
      end
      report["images"].each do |image|
        r.images.attach(io: URI.open(image), filename: "#{report["id"]}")
      end
      if r != nil
        r.save
      end
      pp "there are #{Report.count} reports"
      sleep(2)
    end
  end

  pp "there are #{Report.count} reports"
  
  uri = URI("https://whitehouseuprising.github.io/maps2/data/chicago/all.json")
  response = Net::HTTP.get(uri)
  json = JSON.parse(response)
  json.each do |report|
    if !Report.exists?(blu_id: report["properties"]["id"])
      r = Report.new(
        blu_id: report["properties"]["id"],
        reporter_id: 1,
        category: report["properties"]["obstruction"],
        lat: report["geometry"]["coordinates"][1],
        lng: report["geometry"]["coordinates"][0],
      )
    else
      r = Report.find_by(blu_id: report["properties"]["id"])
      r.lat = report["geometry"]["coordinates"][1]
      r.lng = report["geometry"]["coordinates"][0]
      r.category = report["properties"]["obstruction"]
      r.save
    end
  end
  pp "there are #{Report.count} reports"
end
