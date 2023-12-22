class GeoService

  #This service is to interact with the geocode api.  It will take an
  #address and return the coordinates, or take coordinates and return the
  #address.  This is a free service so long as I only use it less than once
  #per second.

  def initialize
    @base_url = "https://geocode.maps.co/"
  end

  def geo_encode(address)
    uri = URI("#{@base_url}search?q=#{address}")
    pp uri
    response = Net::HTTP.get(uri)
    pp response
    json = JSON.parse(response)
    pp json
    coord = {
      lat: json[0]["lat"].to_f,
      lon: json[0]["lon"].to_f,
    }
    return coord
  end

  def reverse_geo(lat, lon)
    uri = URI("#{@base_url}reverse?lat=#{lat}&lon=#{lon}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    address = json["address"]
    return address
  end
end
