class PathfinderController < ApplicationController

  def show
  end

  def findRoute
    startAddress = params[:startAddress]
    endAddress = params[:endAddress]
    # root_url = "https://router.hereapi.com/v8/routes?"
    # apiKey = Rails.application.credentials.here[:api_key]
    @avoidAreas = setAvoidanceAreas()
    # full_url = root_url + "origin=#{findCoordinates(startAddress)}&destination=#{findCoordinates(endAddress)}&transportMode=bicycle&avoid[areas]=#{avoidAreas.join("|")}&alternatives=3&return=polyline&apiKey=#{apiKey}"
    # uri = URI(full_url)
    # response = Net::HTTP.get(uri)
    @origin = findCoordinates(startAddress)
    @destination = findCoordinates(endAddress)
    respond_to do |format|
      format.html { render "pathfinder/findRoute" }
    end
  end

  def findCoordinates(address)
    root_url = "https://geocode.search.hereapi.com/v1/geocode?"
    apiKey = Rails.application.credentials.here[:api_key]
    full_url = root_url + "q=#{address}&apiKey=#{apiKey}"
    uri = URI(full_url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)["items"][0]
    return "#{json["position"]["lat"]},#{json["position"]["lng"]}"
  end


  def setAvoidanceAreas
    areas = Array.new
    # constURI = URI("https://chistreetwork.chicago.gov/publicapi/temporal_entity/street_closure_permit/")
    # eventURI = URI("https://chistreetwork.chicago.gov/publicapi/temporal_entity/street_closure_event/")
    # constResponse = Net::HTTP.get(constURI)
    # eventResponse = Net::HTTP.get(eventURI)
    # constJson = JSON.parse(constResponse)
    # eventJson = JSON.parse(eventResponse)
    # constNext = constJson["next"]
    # constPrev = constJson["previous"]
    # eventNext = eventJson["next"]
    # eventPrev = eventJson["previous"]
    # constJson["results"].each do |const|
    #   attrs = const["attrs"]
    #   shape = const["shape"]
    #   if attrs["current_milestone"] == "Completed"
    #     next
    #   end
    #   if shape["type"] == "LineString"
    #     area = "corridor:"
    #     shape["coordinates"].each do |coord|
    #       area += "#{coord[0]},#{coord[1]},"
    #     end
    #     areas.push(area)
    #   end
    # end
    # eventJson["results"].each do |event|
    #   attrs = event["attrs"]
    #   shape = attrs["shape"]
    #   if shape["type"] == "LineString"
    #     area = "corridor:"
    #     shape["coordinates"].each do |coord|
    #       area += "#{coord[0]},#{coord[1]},"
    #     end
    #     areas.push(area)
    #   end
    # end
    reports = Report.where.not(category: "Construction").where("created_at > ?", 1.days.ago)
    reports.each do |report|
      box = "#{report.lng.to_f - 0.0002777777777777778},#{report.lat.to_f - 0.0002777777777777778},#{report.lng.to_f + 0.0002777777777777778},#{report.lat.to_f + 0.0002777777777777778}"
      areas.push("bbox:#{box}")
    end

    return areas
  end
end
