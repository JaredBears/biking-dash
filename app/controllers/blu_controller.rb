class BluController < ApplicationController
  def initialize
    @geo = GeoencoderController.new
    @starting = 0
    @ending = 0
    @new_reports = {}
  end

  def import_data
    initial_count = Report.count
    @starting = initial_count == 0 ? 62800 : Report.order(blu_id: :desc).first.blu_id
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
      @new_reports[report.dig("properties", "id")] = {
        blu_id: report.dig("properties", "id"),
        category: report.dig("properties", "category"),
        lat: report.dig("geometry", "coordinates")[1],
        lng: report.dig("geometry", "coordinates")[0],
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

        address_info = @geo.reverse_geo(curr_report[:lat], curr_report[:lng])

        pp "updating report #{id}..."

        pp address_info

        curr_report.merge!({
          created_at: DateTime.strptime(blu_report["dateReceived"], "%Y-%m-%dT%H:%M:%S.%LZ"),
          address_street: "#{address_info["house_number"]} #{address_info["road"]}",
          address_zip: address_info["postcode"],
          neighborhood: address_info["neighbourhood"],
          suburb: address_info["suburb"],
          images: blu_report["images"],
        })
        pp curr_report
        sleep(rand(1..3))
      end
      sleep(1)
    end
  end

  def synchronize_data
    @starting..@ending.each do |id|
      if @new_reports[id] == nil
        next
      end
      pp "Syncing blu_report #{id}..."
      r = Report.new(
        blu_id: @new_reports[id][:blu_id],
        category: @new_reports[id][:category],
        lat: @new_reports[id][:lat],
        lng: @new_reports[id][:lng],
        created_at: @new_reports[id][:created_at],
        address_street: @new_reports[id][:address_street],
        address_zip: @new_reports[id][:address_zip],
        neighborhood: @new_reports[id][:neighborhood],
        suburb: @new_reports[id][:suburb],
        reporter_id: 1,
      )
      if Rails.env.production?
        @new_reports[id]["images"].each do |image|
          if image[-3..-1] == "png"
            next
          end
          pp "adding image #{image} to report #{r.id}..."
          r.images.attach(io: URI.open(image), filename: "#{r.id}")
          sleep(rand(1..5))
        end
      end
      r.save
      pp Report.find(r.id)
    end
  end
end
