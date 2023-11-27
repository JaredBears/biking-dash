require 'net/http'
require 'json'

#This class is used to get the JSON file from the BLU API and add each report to the database if not already added

class BluAPI

  #Initialize the class with the URL to the BLU API
  def initialize()
    @blu_url = "https://feed.bikelaneuprising.com/api/feed"
    @whu_url = "https://whitehouseuprising.github.io/maps2/data/chicago/all.json"
  end

  #Get the JSON file from the BLU API and add each report to the database if not already added
  def get_blu_json
    continue = true
    iterator = ""

    while continue do
      uri = URI("#{@blu_url}?after=#{iterator}")
      response = Net::HTTP.get(uri)
      json = JSON.parse(response)
      if iterator == json["iterator"]
        continue = false
        break
      end
      iterator = json["iterator"]
      json["data"].each do |report|
        r = nil
        if !Report.exists?(blu_id: report["id"]) && report["city"] == "Chicago, IL"
          r = Report.new(
            blu_id: report["id"],
            reporter_id: 1,
            category: "Unknown",
            created_at: DateTime.strptime(report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ"),
            complete_blu: false
          )
        else
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
      end
    end
    
  end

  def get_whu_json
    uri = URI(@whu_url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    10.times do |i|
      pp json[i]["properties"]["id"]
    end
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
      pp "there are #{Report.count} reports"
    end
  end

end

blu = BluAPI.new()
blu.get_whu_json()
