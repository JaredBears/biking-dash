desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  Report.destroy_all
  ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
  ActiveStorage::Blob.all.each { |blob| blob.purge }
end

desc "Import data from the BLU API and WHU API and add it to the database"
task({ :import_data => :environment }) do
  initial_count = Report.count
  uri = URI("https://whitehouseuprising.github.io/maps2/data/chicago/all.json")
  response = Net::HTTP.get(uri)
  json = JSON.parse(response)
  r = nil
  json.sort_by! { |report| report["properties"]["id"] }.reverse!
  json.each do |report|
    if !Report.exists?(blu_id: report["properties"]["id"])
      pp "new report"
      pp report["properties"]["id"]
      r = Report.new(
        blu_id: report["properties"]["id"],
        reporter_id: 1,
        category: report["properties"]["obstruction"],
        lat: report["geometry"]["coordinates"][1],
        lng: report["geometry"]["coordinates"][0],
        complete_blu: false,
      )
      r.save
    else
      pp "report already exists"
      pp report["properties"]["id"]
      # display the report with the highest blu_id
      pp Report.order(blu_id: :desc).first
      pp Report.find_by(blu_id: report["properties"]["id"])
      break
    end
    r = nil
  end
  pp "there are #{Report.count} reports"
  new_count = Report.count - initial_count
  pp "there are #{new_count} new reports"

  continue = true
  iterator = ""
  if new_count == 0 && BluIterator.count > 0
    iterator = BluIterator.last.iterator
  end

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
      if Report.exists?(blu_id: report["id"])
        r = Report.find_by(blu_id: report["id"])
        if !r.complete_blu
          r.update(
            complete_blu: true,
            created_at: DateTime.strptime(report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ"),
          )
          # if dateReceived is within the last month:
          if r.created_at > DateTime.now - 1.month
            report["images"].each do |image|
              r.images.attach(io: URI.open(image), filename: "#{report["id"]}")
            end
          end
          r.save
          # How many reports have been marked complete?
          pp "there are #{Report.where(complete_blu: true).count} complete reports"
        end
      end
      r = nil
    end
    BluIterator.create(iterator: iterator)
    sleep(rand(1..15))
  end
end
