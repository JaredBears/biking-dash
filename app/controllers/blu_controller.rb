class BluController < ApplicationController
  def initialize
    @geo = GeoencoderController.new
    @starting = 0
    @ending = 0
    @new_reports = {}
  end

  def import_data
    initial_count = Report.count
    @starting = initial_count == 0 ? 64319 : Report.order(blu_id: :desc).first.blu_id
    import_whu_data
    import_blu_data
    synchronize_data
  end

  private

  def import_whu_data()
    uri = URI("https://whitehouseuprising.github.io/maps2/data/chicago/all.json")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)

    json.sort_by! { |report| report.dig("properties", "id") }
    @ending = json.last.dig("properties", "id")

    first_index = json.find_index { |report| report.dig("properties", "id") == @starting }
    json = json[first_index..-1]
    json.each do |report|
      pp "adding report #{[report.dig("properties", "id")]} to new_reports..."
      if report.dig("properties", "obstruction")[0..4] == "Other"
        report.dig("properties", "obstruction")[0..-1] = "Other  (damaged lane / snow / debris / pedestrian / etc.)"
      end
      @new_reports[report.dig("properties", "id")] = {
        blu_id: report.dig("properties", "id"),
        category: report.dig("properties", "obstruction"),
        lat: report.dig("geometry", "coordinates")[1],
        lon: report.dig("geometry", "coordinates")[0],
      }
      pp @new_reports[report.dig("properties", "id")]
    end
    return 0
  end

  def import_blu_data

    continue = true

    iterator = ""

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
        curr_report = @new_reports[id]

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
    end
    if Rails.env.development?
      # save @new_reports to a json file
      pp "saving new_reports to json file..."
      File.open("new_reports.json","w") do |f|
        f.write(@new_reports.to_json)
      end
    end
  end

  def synchronize_data
    pp "synchronizing data..."
    pp "starting at #{@starting} and ending at #{@ending}"
    @new_reports.each do |blu_id, report|
      pp report
      pp "Syncing blu_report #{blu_id}..."
      r = Report.create({
        blu_id: blu_id,
        category: report[:category],
        lat: report[:lat],
        lon: report[:lon],
        created_at: report[:created_at],
        address_street: report[:address_street],
        address_zip: report[:address_zip],
        neighborhood: report[:neighborhood],
        suburb: report[:suburb],
        reporter_id: report[:reporter_id],
      })
      # try to save the report and if not successful, display the errors
      pp r
      r.errors.full_messages.each do |message|
        pp message
      end

      if Rails.env.production?
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
end
