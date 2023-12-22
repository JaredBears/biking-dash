class BluService
  def initialize
  end

  def import_blu_data
    continue = true
    if new_reports["reports"].nil?
      # read from json file
      pp "reading from json file..."
      new_reports = JSON.parse(File.read("new_reports.json"))
    end
    iterator = @new_reports["iterator"].nil? ? "" : @new_reports["iterator"]

    pp "start loop"

    while continue
      uri = URI("https://feed.bikelaneuprising.com/api/feed?after=#{iterator}")
      response = Net::HTTP.get(uri)
      json = JSON.parse(response)

      #If I've hit the end of the data, break out of the loop
      if iterator == json["iterator"]
        continue = false
        break
      end
      iterator = json["iterator"]

      json["data"].each do |blu_report|
        id = blu_report["id"].to_i
        curr_report = @new_reports["reports"][id]

        # this API runs newest to oldest, so if I hit the starting id I should stop
        # if the report doesn't exist on my end,
        # it's for a different city and I should skip it
        if id < @starting
          continue = false
          break
        elsif curr_report.nil?
          next
        end

        pp "report #{id} does exist"

        pp curr_report

        address_info = @geo.reverse_geo(curr_report[:lat], curr_report[:lon])

        pp "updating report #{id}..."

        pp address_info
        if address_info.nil?
          address_info = {
            "house_number" => "",
            "road" => "",
            "postcode" => "",
            "neighbourhood" => "",
            "suburb" => "",
          }
        end

        curr_report.merge!({
          created_at: DateTime.strptime(blu_report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ"),
          address_street: "#{address_info["house_number"]} #{address_info["road"]}",
          address_zip: address_info["postcode"],
          neighborhood: address_info["neighbourhood"],
          suburb: address_info["suburb"],
          images: blu_report["images"],
          reporter_id: 1,
        })
        pp curr_report
        sleep(rand(1..3))
      end
      sleep(1)
      if Rails.env.development?
        pp "saving new_reports to json file..."
        File.open("new_reports#{Date.Today}.json", "w") do |f|
          f.write(@new_reports.to_json)
        end
      end
    end
  end
  
end
